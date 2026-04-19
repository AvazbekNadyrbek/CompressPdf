# PDF Squeeze

A native iOS app that compresses PDF files using a Ghostscript-powered backend. Pick a file, choose a quality level, and get a smaller PDF in seconds.

---

## Features

- **One-tap compression** — select a PDF from Files, iCloud, or any share extension
- **Three quality presets** — Maximum compression, Balanced, or Quality-preserving
- **Live progress bar** — animated feedback while the server processes the file
- **Compression stats** — before/after file size and exact savings percentage
- **Instant save** — share or save the compressed file via the system share sheet
- **Privacy notice** — files are deleted from the server immediately after compression

---

## Requirements

| Component | Version |
|---|---|
| Xcode | 26.2+ |
| iOS deployment target | 26.2+ |
| Swift | 6.2 |
| Backend | Node.js / any server with Ghostscript (see below) |

## Screenshots

<img width="468" height="929" alt="Screenshot 2026-04-19 at 18 09 58" src="https://github.com/user-attachments/assets/8c3f4c0a-c0ae-4b27-ba48-88115728d267" />

<img width="491" height="986" alt="Screenshot 2026-04-19 at 18 10 08" src="https://github.com/user-attachments/assets/862456cd-a6d1-4bc6-b64d-4a749b2f3ca0" />


---

## Architecture

```
CompressPdf/
├── CompressPdfApp.swift          # App entry point
├── ContentView.swift             # State router (idle / loading / result / error)
├── Models/
│   ├── Quality.swift             # Compression quality enum (max / balance / high)
│   └── CompressResult.swift      # Result model with size helpers
├── ViewModel/
│   └── CompressViewModel.swift   # @Observable @MainActor state machine
├── Service/
│   └── PDFCompressService.swift  # Multipart POST to /api/pdf/compress
├── Views/
│   ├── HomeView.swift            # File picker + quality selector + compress button
│   ├── ProcessingView.swift      # Animated progress during compression
│   ├── ResultView.swift          # Stats card + save/share actions
│   ├── ErrorView.swift           # Error state with retry
│   ├── AnimatedCompressionIcon.swift  # Pulsing icon used in ProcessingView
│   └── ShareSheet.swift          # UIActivityViewController wrapper
└── Extensions/
    └── Color.swift               # Color(hex:) initializer
```

**Pattern:** MVVM with enum-based view state (`idle`, `loading`, `result`, `error`). `ContentView` switches on `viewModel.viewState` to route between screens.

**Concurrency:** The compress operation uses `async let` so the progress animation and the network request run concurrently. The service method is marked `@concurrent` to offload multipart body construction and the network call off the main actor.

---

## Backend

The app posts to `http://localhost:8080/api/pdf/compress`.

**Request** — `multipart/form-data` with two fields:

| Field | Type | Description |
|---|---|---|
| `file` | PDF binary | The file to compress |
| `quality` | String | `low`, `medium`, or `high` |

**Response** — raw compressed PDF bytes (`application/pdf`) on HTTP 200, or an error body on any other status.

A minimal backend can be run with Ghostscript:

```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/screen \   # low | /ebook = medium | /prepress = high
   -dNOPAUSE -dBATCH \
   -sOutputFile=output.pdf input.pdf
```

---

## Getting Started

1. Clone the repo and open `CompressPdf.xcodeproj` in Xcode 26.2+.
2. Start your Ghostscript backend on `http://localhost:8080`.
3. Select a simulator or device running iOS 26.2+.
4. Build and run (`⌘R`).

To point the app at a different server, change `baseURL` in `PDFCompressService.swift`:

```swift
private let baseURL = "https://your-server.example.com"
```

> **Note:** The app currently uses plain HTTP (`http://`). For production, switch to HTTPS and add the server domain to the app's Info.plist `NSAppTransportSecurity` exceptions, or use a properly signed TLS certificate.

---

## Compression Quality Levels

| Preset | `quality` value | Ghostscript equivalent | Use case |
|---|---|---|---|
| Maximum | `low` | `/screen` | Smallest file, email attachments |
| Balanced | `medium` | `/ebook` | Good size/quality tradeoff |
| Quality | `high` | `/prepress` | Print-ready, minimal loss |

---

## License

MIT
