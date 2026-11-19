# dsbot-relay-docker

DS Bot 手机链路中转服务（relay server）的容器镜像。

中转只转发手机与电脑之间的加密帧，读不到内容。服务端源码在 [Fei2411/DS-Bot](https://github.com/Fei2411/DS-Bot) 的 `link/` 目录（Apache-2.0），镜像按固定提交构建。

## 用法

```sh
docker run -d --name dsbot-relay \
  -p 8787:8787 \
  -v relay-data:/data \
  ghcr.io/littleorcaagent/dsbot-relay-docker:edge
```

服务本身只说 `ws://`。前面要放一层 TLS 反代，手机端填的 `wss://` 地址以 `/v1/link` 结尾。

进程在跑时 `GET /healthz` 返回 `200 ok`。

## 配置

| 变量 | 默认值 | |
|---|---|---|
| `HOST`, `PORT` | `0.0.0.0`, `8787` | 监听地址 |
| `DSBOT_LINK_DATA` | `/data/devices.json` | 已知设备的存档文件；留空则只存在内存里 |
| `DSBOT_LINK_TRUST_PROXY` | 关 | `1`：从 `X-Forwarded-For` 最后一项取客户端地址。只在有反代会写这个头时开 |
| `DSBOT_LINK_MAX_SOCKETS` | `1024` | 同时打开的连接总数 |
| `DSBOT_LINK_MAX_LINKS` | `1024` | 手机与电脑之间的链路总数 |
| `DSBOT_LINK_MAX_SOCKETS_PER_ADDRESS` | `256` | 单个地址的连接数 |
| `DSBOT_LINK_MAX_NEW_DEVICES_PER_HOUR` | `20` | 单个地址每小时可注册的新设备数 |
| `DSBOT_LINK_MAX_MB_PER_HOUR` | `512` | 单个地址每小时可发送的 MiB |
| `DSBOT_LINK_DEVICE_TTL_DAYS` | 无 | 超过这么多天没出现的设备会被遗忘 |

容器以 uid 1000 运行，挂载的 `/data` 必须对该用户可写。

## 构建

GitHub Actions 在推送到 `main`、打 `v*` 标签、每周定时和手动触发时构建。要换上游提交，用 `--build-arg DSBOT_REF=<sha>`。

## 标签

`edge` 跟随 `main`。`sha-<短哈希>` 是一次具体构建。`vX.Y.Z` 来自标签。

## 许可

中转服务端为 Apache-2.0，来自 [Fei2411/DS-Bot](https://github.com/Fei2411/DS-Bot)。
