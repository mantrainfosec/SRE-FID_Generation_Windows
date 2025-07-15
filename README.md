# Automated Function ID Database Generation for Ghidra on Windows

This repository contains PowerShell scripts that automate the process of generating **Function ID (FID) databases** in [Ghidra](https://ghidra-sre.org/) for statically linked Windows libraries — especially useful when symbol information is stripped from binaries.

The process helps reverse engineers identify known functions by applying pre-generated function signatures to decompiled code, similar to IDA Pro’s FLIRT technology.

## Why This Exists

When analyzing stripped Windows binaries using statically linked libraries (e.g. OpenSSL), manually identifying functions can be tedious and error-prone. While tools and guides exist for Linux, this workflow fills the gap for **Windows-based analysis** by automating:

1. Extracting `.obj` files from `.lib` static archives  
2. Importing those `.obj` files into a Ghidra project  
3. Generating Ghidra-compatible Function ID databases (FIDBs)

---

## Scripts Overview

### 1. `01Extract-LibContents.ps1`
Extracts individual `.obj` files from a given `.lib` static library using the `lib.exe` utility (part of Visual Studio toolchain).

```powershell
.\01Extract-LibContents.ps1 .\libssl_static.lib
```

### 2. `02Import-Ghidra.ps1`
Creates a new Ghidra project (or uses an existing one), then batch-imports all .obj files for analysis.

```powershell
.\02Import-Ghidra.ps1 libssl_static openssl-libssl "C:\Users\USER\Desktop\ghidra_11.3.2_PUBLIC"
```

#### Parameters:
* `libssl_static` → Folder containing `.obj` files
* `openssl-libssl` → Name of the Ghidra project
* `C:\...` → Path to your Ghidra installation

### 3. `03Generate-FIDB.ps1`

Generates the Function ID database (.fidb) from the Ghidra project.

```powershell
.\03Generate-FIDB.ps1 libcrypto_static openssl-libcrypto "C:\Users\USER\Desktop\ghidra_11.3.2_PUBLIC"
```

Note: Once generated, you can apply the `.fidb` via Ghidra:
`Analysis > One Shot > Function ID`

### Blog Post:

Read the full write-up here:
[Automated Function ID Database Generation in Ghidra on Windows](https://blog.mantrainfosec.com/blog/17/automated-function-id-database-generation-in-ghidra-on-windows)

### Credits

Based on the original Linux scripts and write-up by [@0x6d696368](https://blog.threatrack.de/2019/09/20/ghidra-fid-generator/).
This Windows adaptation by Balazs Bucsay from Mantra Information Security.
