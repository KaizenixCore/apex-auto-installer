<div align="center">

# 🚀 APEX Auto Installer

### ابزار نصب خودکار و هوشمند استک اوراکل اپکس
#### لینوکس • ویندوز • داکر

[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge&logo=github)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Oracle](https://img.shields.io/badge/Oracle-Database-F80000.svg?style=for-the-badge&logo=oracle&logoColor=white)](https://ir.oracle.com/)
[![Made By](https://img.shields.io/badge/Made%20by-KaizenixCore-black?style=for-the-badge&logo=github)](https://github.com/KaizenixCore)

<br/>

**Choose Your Language / زبان خود را انتخاب کنید**

<h1>
  <a href="./README.md">🇬🇧 English</a>
  &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="./README.fa.md">🇮🇷 فارسی</a>
</h1>

<br/>

</div>

<div dir="rtl" align="right">

---

## ⚡ این پروژه چیست؟

**APEX Auto Installer** یک ابزار اتوماسیون هوشمند است که تمام استک اوراکل اپکس را با **یک دستور** نصب می‌کند.

دیگر دوران تنظیمات دستی، درگیری با وابستگی‌ها و نصب‌های ناقص به پایان رسیده است. چه روی **لینوکس** باشید، چه **ویندوز** و چه از **داکر** استفاده کنید، ما هوای شما را داریم.

### 🏗️ اجزای نصب شده

| کامپوننت | نسخه | توضیحات |
|:---:|:---:|:---|
| 🗄️ **دیتابیس** | **XE 21c** | نسخه اکسپرس دیتابیس اوراکل |
| ⚡ **اپکس** | **آخرین نسخه** | پلتفرم توسعه Oracle APEX |
| 🔗 **ORDS** | **آخرین نسخه** | سرویس‌های REST اوراکل |

---

## 🚀 شروع سریع (پیشنهادی)

سریع‌ترین راه برای شروع، استفاده از **داکر (Docker)** است.

</div>

```bash
# ۱. دریافت پروژه
git clone https://github.com/KaizenixCore/apex-auto-installer.git

# ۲. رفتن به پوشه داکر
cd apex-auto-installer/docker

# ۳. پرتاب موشک 🚀
docker-compose up -d

