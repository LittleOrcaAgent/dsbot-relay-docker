# dsbot-relay-docker

Container image for the DS Bot phone-link relay server.

The relay forwards encrypted frames between the DS Bot phone app and the computer and cannot read them. The server source lives in [Fei2411/DS-Bot](https://github.com/Fei2411/DS-Bot) under `link/` (Apache-2.0) and is built into this image at a pinned commit.

## Usage

```sh
docker run -d --name dsbot-relay \
  -p 8787:8787 \
  -v relay-data:/data \
  ghcr.io/littleorcaagent/dsbot-relay-docker:edge
```

The server speaks plain `ws://`. Put a TLS proxy in front of it and give phones the `wss://` address ending in `/v1/link`.

`GET /healthz` answers `200 ok` while the process is up.

## Configuration

| Variable | Default | |
|---|---|---|
| `HOST`, `PORT` | `0.0.0.0`, `8787` | Where the server listens |
| `DSBOT_LINK_DATA` | `/data/devices.json` | File for known devices; empty keeps them in memory only |
| `DSBOT_LINK_TRUST_PROXY` | off | `1`: take the client address from the last `X-Forwarded-For` entry. Set it only behind a proxy that writes this header |
| `DSBOT_LINK_MAX_SOCKETS` | `1024` | Open sockets in total |
| `DSBOT_LINK_MAX_LINKS` | `1024` | Phone-to-computer links in total |
| `DSBOT_LINK_MAX_SOCKETS_PER_ADDRESS` | `256` | Open sockets from one address |
| `DSBOT_LINK_MAX_NEW_DEVICES_PER_HOUR` | `20` | New devices one address may register in an hour |
| `DSBOT_LINK_MAX_MB_PER_HOUR` | `512` | MiB one address may send in an hour |
| `DSBOT_LINK_DEVICE_TTL_DAYS` | none | Forget devices not seen for this many days |

The container runs as uid 1000. A mounted `/data` must be writable by that user.

## Build

GitHub Actions builds on push to `main`, on `v*` tags, weekly, and on demand. Pin a different upstream commit with `--build-arg DSBOT_REF=<sha>`.

## Tags

`edge` follows `main`. `sha-<short>` is one exact build. `vX.Y.Z` comes from a tag.

## License

The relay server is Apache-2.0, from [Fei2411/DS-Bot](https://github.com/Fei2411/DS-Bot).
