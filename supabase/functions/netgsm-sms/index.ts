import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const NETGSM_USERCODE = Deno.env.get("NETGSM_USERCODE") || "";
const NETGSM_PASSWORD = Deno.env.get("NETGSM_PASSWORD") || "";
const NETGSM_HEADER = Deno.env.get("NETGSM_HEADER") || "";

serve(async (req: Request) => {
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

    // 2. Format phone number (remove leading + for Netgsm)
    // E.g. "+905051234567" becomes "905051234567"
    const cleanPhone = phone.replace("+", "");

    const messageText = `İzge App doğrulama kodunuz: ${otp}. Bu kodu kimseyle paylaşmayınız.`;

    // 3. Make request to Netgsm HTTP API
    const response = await fetch("https://api.netgsm.com.tr/sms/send/get", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: new URLSearchParams({
        usercode: NETGSM_USERCODE,
        password: NETGSM_PASSWORD,
        gsm: cleanPhone,
        text: messageText,
        msgheader: NETGSM_HEADER,
      }),
    });

    const resultText = await response.text();

    // Netgsm returns "00 <job_id>" on success, or error code on failure (e.g. "20", "30", etc.)
    if (resultText.startsWith("00")) {
      return new Response(JSON.stringify({ success: true, job_id: resultText.split(" ")[1] }), {
        headers: { "Content-Type": "application/json" },
        status: 200,
      });
    } else {
      return new Response(JSON.stringify({ error: `Netgsm error: ${resultText}` }), {
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
