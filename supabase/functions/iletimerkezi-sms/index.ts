const ILETIMERKEZI_KEY = Deno.env.get("ILETIMERKEZI_KEY") || "";
const ILETIMERKEZI_HASH = Deno.env.get("ILETIMERKEZI_HASH") || "";
const ILETIMERKEZI_SENDER = Deno.env.get("ILETIMERKEZI_SENDER") || "";

Deno.serve(async (req: Request) => {
  try {
    // 1. Get SMS payload from Supabase Auth hook
    const payload = await req.json();
    
    const phone = payload?.user?.phone;
    const otp = payload?.sms?.otp;

    if (!phone || !otp) {
      console.error("Missing phone or OTP in payload", payload);
      return new Response(JSON.stringify({ error: "Missing phone or OTP code" }), {
        headers: { "Content-Type": "application/json" },
        status: 200, // Returning 200 so Supabase doesn't crash with unexpected_failure, but delivery will fail.
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
        request: {
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
        }
      })
    });

    const result = await response.json();

    // Check Ileti Merkezi response status
    if (result && result.response && result.response.status && result.response.status.code === 200) {
      // Supabase Auth Hook expects an empty JSON response or the unmodified payload
      return new Response(JSON.stringify({}), {
        headers: { "Content-Type": "application/json" },
        status: 200,
      });
    } else {
      const errMsg = result?.response?.status?.message || "Unknown error";
      console.error("Ileti Merkezi Error:", errMsg, result);
      return new Response(JSON.stringify({}), {
        headers: { "Content-Type": "application/json" },
        status: 200,
      });
    }
  } catch (error: any) {
    console.error("Edge Function Exception:", error.message);
    return new Response(JSON.stringify({}), {
      headers: { "Content-Type": "application/json" },
      status: 500,
    });
  }
});
