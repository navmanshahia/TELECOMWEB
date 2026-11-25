# SecureLink Telecom
Development preview, not a production service. Run npm install and npm run dev (Node 20.9+). Routes: /, /availability, /checkout, /track, /sales, /admin. Sample plans only. Motion transitions use reduced-motion preferences. No sensitive data is accepted or transmitted.

## Production blockers
- Authorized TELUS/Rogers/Bell qualification APIs; manual verification until available.
- Supabase email OTP with custom SMTP (free tier subject to limits), role-based authorization, private storage, RLS, server-side validation, audit logs and rate limits.
- Carrier-approved ID verification and consent, per-line porting and SIM details, secure notifications, order persistence and tracking.
- Real catalogue, pricing, discount/referral rules, QR codes, WhatsApp and support configuration.
- Test build, accessibility, performance, security and deployment. Never commit credentials or customer data.
