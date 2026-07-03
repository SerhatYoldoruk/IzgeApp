-- Create user_devices table
CREATE TABLE IF NOT EXISTS public.user_devices (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    fcm_token text UNIQUE NOT NULL,
    device_type text, -- 'android' or 'ios'
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);

-- Enable RLS
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can insert their own device tokens" ON public.user_devices
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can select their own device tokens" ON public.user_devices
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own device tokens" ON public.user_devices
    FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own device tokens" ON public.user_devices
    FOR DELETE USING (auth.uid() = user_id);

-- Index for fast user-specific lookups
CREATE INDEX IF NOT EXISTS idx_user_devices_user_id ON public.user_devices (user_id);
