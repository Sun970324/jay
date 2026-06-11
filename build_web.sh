#!/bin/bash
flutter build web
cp -r vercel_src/api build/web/
cp vercel_src/package.json build/web/
cp vercel_src/vercel.json build/web/
echo "✓ Vercel files copied to build/web"
