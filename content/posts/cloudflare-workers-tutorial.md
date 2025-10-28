---
title: "Cloudflare Workers 实战：用边缘计算打造免费中转服务"
date: 2025-10-27
draft: false
tags: ["Cloudflare", "Workers", "Serverless", "边缘计算"]
categories: ["网络技术", "教程"]

cover:
  image: "/images/cloudflare-workers-cover.jpg"
  alt: "Cloudflare Workers 实战"
  caption: "由 Cloudflare 提供的边缘计算服务"
  relative: false
---

## 前言：边缘计算，不只是加速网页

很多人知道 Cloudflare 提供免费 CDN（内容分发网络），但其实它的「Workers」功能更有趣——它让开发者在全球 300 多个节点上运行自定义脚本，相当于你拥有一个分布在世界各地的迷你云平台。

这意味着你可以让一个 JS 文件，在离用户最近的节点上实时处理请求、转发数据、加密流量——完全不需要传统服务器。

今天我们就来看看：如何用 Workers 部署一个简单的「中转服务」，让请求能自动从最近节点发出，体验“免费且分布式的边缘计算威力”。

---

## 一、原理概览：Workers 是什么？

Cloudflare Workers 基于 V8 引擎（Chrome 的 JavaScript 核心），本质上是运行在 Cloudflare 全球网络上的轻量无服务器函数 (Serverless Function)。

你写几行 JS 代码，它就能在 Cloudflare 节点执行逻辑，比如：

- 动态修改请求头  
- 过滤或转发请求  
- 作为中间层 API  
- 构建轻量代理或数据缓存  

因此，无需 Nginx 或 VPS，只要写代码并部署即可。

---

## 二、准备工作

1. **注册 Cloudflare 账号**  
   [Cloudflare 控制台](https://dash.cloudflare.com)

2. **进入 “Workers & Pages”**  
   点击 “Create Worker”，系统会生成一个默认的 Hello World 脚本。

3. **安装 Wrangler 命令行工具（可选）**  
   ```bash
   npm install -g wrangler
   wrangler login
   它可以帮助你快速上传代码、配置 KV 存储、管理命名空间。

## 三、核心思路：请求转发逻辑

在 Workers 里，你可以拦截请求，然后修改路径或转发到目标站点。

示例（教育用途）：
```export default {
  async fetch(request) {
    const url = new URL(request.url);
    // 将请求转发到目标域名
    url.hostname = "example.com";
    return fetch(url, request);
  }
}
这段代码可以在 Cloudflare 边缘节点实现一个轻量中转层，系统会自动处理 TLS 、缓存 与 全局路由。
```

## 四、优化与安全

1. **自定义域名**
    绑定自己的域名，例如 `api.novaedge.vip`。
2. **访问控制**
    添加 header 验证或 API Key 限制。
3. **KV 存储支持**
    可写入 Cloudflare KV，用于动态切换节点或记录统计数据。
4. **日志与监控**
    在 Dashboard 查看调用次数、延迟、区域分布。

------

## 五、性能与限制

- 免费版 Workers 约 10 万次请求/天；
- 单次执行上限 10 ms；
- 不适合全量代理，但非常适合 API 中转、轻缓存；
- 延迟极低，可直接分发小文件或图片。

------

## 六、延伸玩法

1. **多区域中转**：根据地理位置分配不同节点。
2. **前端加速**：让博客图片、静态资源走 Workers 分发。
3. **轻量 API 网关**：只转发特定路径如 `/api/v1/data`，其余拒绝访问。

------

## 七、结语：把 Cloudflare 玩出花

Cloudflare Workers 是最容易上手的 Serverless 平台之一。
 它让开发者在全球节点运行逻辑，实现“无服务器、全球加速”。
 用它做轻量转发只是冰山一角——真正的乐趣，是让程序不再依赖某台主机，而是运行在世界各地的边缘节点上。
-----