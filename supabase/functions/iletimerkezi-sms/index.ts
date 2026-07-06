const ILETIMERKEZI_KEY = Deno.env.get("ILETIMERKEZI_KEY") || "";
const ILETIMERKEZI_HASH = Deno.env.get("ILETIMERKEZI_HASH") || "";
const ILETIMERKEZI_SENDER = Deno.env.get("ILETIMERKEZI_SENDER") || "";

Deno.serve(async (req: Request) => {
  try {
    // 1. Get SMS payload from Supabase Auth hook
    const { sms } = await req.json();
    const { phone, otp } = sms;

    if (!phone || !otp) {
      return new Response(JSON.stringify({ error: "Missing phone or OTP code" }), {
        headers: { "Content-Type": "application/json" },
        status: 400,
      });
    }

    // 2. Format phone number (remove leading + for Ileti Merkezi)
    // E.g. "+905051234567" becomes "905051234567"
    const cleanPhone = phone.replace("+", "");

    const messageText = `İzge App doğrulama kodunuz: ${otp}. Bu kodu kimseyle paylaşmayınız.`;

    // 3. Make request to Ileti Merkezi JSON API
    const response = await fetch("https://api.iletimerkezi.com/v1/send-sms/json", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        authentication: {
          key: ILETIMERKEZI_KEY,
          hash: ILETIMERKEZI_HASH
        },
        order: {
          sender: ILETIMERKEZI_SENDER,
          sendDateTime: "",
          message: {
            text: messageText,
            receipents: {
              number: [cleanPhone]
            }
          }
        }
      })
    });

    const result = await response.json();

    // Check Ileti Merkezi response status
    // Successful response generally has result.response.status.code == 200
    if (result && result.response && result.response.status && result.response.status.code === 200) {
      return new Response(JSON.stringify({ success: true, order_id: result.response.order?.id }), {
        headers: { "Content-Type": "application/json" },
        status: 200,
      });
    } else {
      const errMsg = result?.response?.status?.message || "Unknown error";
      return new Response(JSON.stringify({ error: `Ileti Merkezi error: ${errMsg}`, details: result }), {
        headers: { "Content-Type": "application/json" },
        status: 400,
      });
    }
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 500,
    });
  }
});
