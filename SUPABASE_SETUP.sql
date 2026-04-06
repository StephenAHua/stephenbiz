-- Initial tables for Stephenbiz

-- 1. Product categories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  parent_id UUID REFERENCES categories(id),
  sort_order INTEGER DEFAULT 0,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Products
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  short_description TEXT,
  category_id UUID REFERENCES categories(id),
  base_price DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  images TEXT[], -- 图片URL数组
  attributes JSONB, -- 颜色、尺寸等变体
  inventory_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  tags TEXT[],
  seo_title TEXT,
  seo_description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Product variants
CREATE TABLE product_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  sku TEXT NOT NULL,
  name TEXT,
  price_adjustment DECIMAL(10,2) DEFAULT 0,
  attributes JSONB, -- { "color": "red", "size": "L" }
  inventory_count INTEGER DEFAULT 0,
  image_url TEXT,
  sort_order INTEGER DEFAULT 0
);

-- 4. User profiles (extends Supabase auth.users)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  company_name TEXT,
  tax_id TEXT,
  website TEXT,
  phone TEXT,
  avatar_url TEXT,
  default_currency TEXT DEFAULT 'USD',
  language TEXT DEFAULT 'en',
  marketing_opt_in BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Shipping addresses
CREATE TABLE shipping_addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  contact_name TEXT NOT NULL,
  company TEXT,
  street_address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT,
  postal_code TEXT NOT NULL,
  country_code TEXT NOT NULL, -- ISO 3166-1 alpha-2
  phone TEXT,
  is_default BOOLEAN DEFAULT false
);

-- 6. Quotes (RFQ)
CREATE TABLE quotes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  product_id UUID REFERENCES products(id),
  variant_id UUID REFERENCES product_variants(id),
  quantity INTEGER NOT NULL,
  custom_requirements TEXT,
  status TEXT CHECK (status IN ('pending', 'responded', 'accepted', 'rejected')) DEFAULT 'pending',
  admin_notes TEXT,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Orders
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT UNIQUE NOT NULL, -- 可读编号 OC-20250406-001
  user_id UUID REFERENCES auth.users(id),
  shipping_address_id UUID REFERENCES shipping_addresses(id),
  billing_address_id UUID REFERENCES shipping_addresses(id),
  status TEXT CHECK (status IN ('draft', 'pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded')) DEFAULT 'draft',
  subtotal DECIMAL(10,2) NOT NULL,
  shipping_fee DECIMAL(10,2) DEFAULT 0,
  tax_amount DECIMAL(10,2) DEFAULT 0,
  total_amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'USD',
  payment_method TEXT, -- stripe, paypal, etc.
  payment_status TEXT CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')) DEFAULT 'pending',
  tracking_number TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Order items
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  variant_id UUID REFERENCES product_variants(id),
  sku TEXT NOT NULL,
  name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL
);

-- 9. Shopping cart (temporary)
CREATE TABLE cart_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  guest_token TEXT, -- 未登录用户标识
  items JSONB NOT NULL DEFAULT '[]',
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. Coupons
CREATE TABLE coupons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  discount_type TEXT CHECK (discount_type IN ('percentage', 'fixed')) NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(10,2) DEFAULT 0,
  valid_from TIMESTAMPTZ DEFAULT NOW(),
  valid_until TIMESTAMPTZ,
  usage_limit INTEGER,
  used_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true
);

-- Create indexes for performance
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_quotes_user ON quotes(user_id);
CREATE INDEX idx_quotes_status ON quotes(status);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_variants ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;

-- Create policies as needed (basic public read for products)
CREATE POLICY "Public can view active products" ON products
  FOR SELECT USING (is_active = true);

CREATE POLICY "Public can view categories" ON categories
  FOR SELECT USING (true);

-- Insert sample data for demo
INSERT INTO categories (name, slug) VALUES
  ('Promotional Products', 'promotional-products'),
  ('Corporate Gifts', 'corporate-gifts'),
  ('Custom Apparel', 'custom-apparel');

INSERT INTO products (sku, name, slug, description, category_id, base_price, currency, images, inventory_count) VALUES
  ('PROD001', 'Custom Logo T-Shirt', 'custom-logo-t-shirt', 'High-quality cotton t-shirt with custom logo printing.', (SELECT id FROM categories WHERE slug = 'custom-apparel'), 12.99, 'USD', ARRAY['https://via.placeholder.com/500x500'], 100),
  ('PROD002', 'Branded Water Bottle', 'branded-water-bottle', 'Stainless steel water bottle with laser engraving.', (SELECT id FROM categories WHERE slug = 'promotional-products'), 8.50, 'USD', ARRAY['https://via.placeholder.com/500x500'], 200),
  ('PROD003', 'Executive Pen Set', 'executive-pen-set', 'Luxury pen set in gift box, perfect for corporate gifts.', (SELECT id FROM categories WHERE slug = 'corporate-gifts'), 25.00, 'USD', ARRAY['https://via.placeholder.com/500x500'], 50);
-- =========================================
-- 使用说明:
-- 1. 在 Supabase SQL Editor 中粘贴此脚本
-- 2. 点击 "Run" 执行
-- 3. 验证表创建成功
-- =========================================

-- 验证表创建
SELECT 
    table_name,
    pg_size_pretty(pg_total_relation_size('public.' || table_name)) as size
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
