# **Awtar – A Minimal Blogging Platform**

Awtar is a lightweight blogging and social platform built **from scratch** with **no third-party backend frameworks**; just **vanilla PHP** along with **MySQL and React**. It allows users to post blogs, comment, like, bookmark, and follow authors for updates.

🚀 **This is not at all a production-ready project**—it’s a personal experiment in full-stack web development, to simply demonstrate RESTful API design, frontend state management, and real-time notifications using **SSE (Server-Sent Events).**

## **Features**

✔️ **Blogging & Comments** – Users can create, read, like, and comment on blogs.  

✔️ **Bookmarking** – Save blogs for later.  

✔️ **Following Authors** – Get notified when they post or edit content.  

✔️ **Notifications** – Real-time updates using **SSE** when someone likes, comments, or posts.  

✔️ **Raw JWT Authentication** – No user registration, just six predefined accounts with a simple JWT system.

✔️ **No Extra Frontend Libraries** – UI built with **plain CSS, React, and Context API** that follows Redux-like patterns.

✔️ **Dockerized for Easy Setup** – Clone, run `docker-compose up`, and you’re good to go.


## **Tech Stack**

🔹 **Frontend**: React (TypeScript) + Context API + CSS (no UI libraries)  

🔹 **Backend**: PHP (no Laravel, no Composer, just raw REST API)  

🔹 **Database**: MySQL with **triggers** to power real-time events  

🔹 **Notifications**: **SSE (Server-Sent Events)** watching the events table  

🔹 **Containerization**: Docker + Docker Compose


## **Setup**

### **Prerequisites**

- **Docker** and **Docker Compose** installed.

### **Run the App**

```bash
git clone https://github.com/Zeph16/awtar.git  
cd awtar  
docker-compose up --build  
```

This will start the backend (PHP + Apache) at **port 8000**, MySQL database at **port 3309**, and frontend (React) at **port 3000** in separate containers.


## **Endpoints & Authentication**

🔹 **Public Endpoints** – Anyone can browse blogs and comments.  

🔹 **Protected Endpoints** – Require a manually generated **JWT token** (hardcoded for demo users).

📌 _Security is NOT a focus here; this is purely for learning._


## **Limitations & Known Issues**

❌ **No real authentication** – Only six predefined users exist.

❌ **No third-party services** – No Firebase, no AWS, just **barebones PHP, Apache & MySQL.**  

❌ **Not production-ready** – Built as a **learning project**, not for hosting.


## **Why I Built This**

Awtar was originally a class project where I challenged myself to build **a full-stack app without relying on modern frameworks.** Instead of Laravel or Next.js, I wanted to manually implement routing, authentication, state management, and real-time features.


This project showcases:  

✅ My ability to build a **REST API** from scratch.  

✅ Handling **state management** in a React app without Redux.  

✅ Using **SSE for real-time notifications.**  

✅ Working with **raw MySQL queries and triggers.**

✅ **Raw CSS** rules and properties to accomplish every styling need. 


## **Want to Try It?**

If you’re interested in how it works, feel free to clone the repo, spin it up with Docker, and explore the code.

⚠️ **Warning**: This is an **amateur project**, not meant for production. **Expect weird design decisions and security flaws.**

## **License**

MIT – Do whatever you want with it.
