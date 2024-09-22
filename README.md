# OS-Core


**OS-Core** is an ongoing project dedicated to learning and developing a basic operating system. This project serves as a hands-on exploration into low-level system programming, operating system architecture, and hardware-software interactions.

## Table of Contents

- [Description](#description)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Future Plans](#future-plans)

## Description

OS-Core is designed to build foundational knowledge in operating system development. By implementing essential components such as the BIOS interface, bootloader, and kernel, this project provides a comprehensive understanding of how operating systems interact with hardware and manage resources.

<img src=""C:\Users\adisi\Downloads\Diagram.png" alt="diagram" />
## Features

- **BIOS Interaction:** Handles low-level hardware initialization and bootstrapping.
- **Bootloader:** Responsible for loading the kernel into memory and preparing the system for operation.
- **Kernel:** Implements core OS functionalities using C++ and Assembly.
- **Memory Management:** Basic mechanisms for handling system memory.
- **Assembly Routines:** Essential assembly code for system setup and operations.

## Installation

### Prerequisites

Ensure you are running Ubuntu (or a similar Linux distribution) and have the following tools installed:

- **GCC (GNU Compiler Collection):** For compiling C/C++ code.
  
  ```bash
  sudo apt update
  sudo apt install build-essential
- **NASM (Netwide Assembler)**: For assembling assembly code.

 ```bash
 sudo apt install nasm
QEMU: Emulator for running and testing the operating system.
```
```bash
sudo apt install qemu
```
## Usage
Clone the Repository
First, clone the repository to your local machine:

```bash
git clone git@github.com:your_username/OS-Core.git
cd OS-Core
```
Compile the Project
Use the provided Makefile to build the project:

```bash
make
```
This command assembles the bootloader, compiles the kernel, links the components, and generates the os.img disk image.

Clean Build Artifacts
To clean up build artifacts and reset the project directory, run:

```bash
make clean
```
Run the Operating System in QEMU
After successfully building the project, you can run the operating system using QEMU:

```bash
qemu-system-i386 -fda bin/os.img -boot a
```
Explanation of Flags:

-fda bin/os.img: Specifies the floppy disk image to use.
-boot a: Boots from the first floppy drive.
Optional: Enable Serial Logging

For enhanced debugging, you can redirect serial output to your terminal:

```bash
qemu-system-i386 -fda bin/os.img -boot a -serial stdio
```

## Future Plans
- **Paging Implementation**: Introduce paging mechanisms to enhance memory management and provide virtual memory support.
Filesystem Support: Develop a basic filesystem to handle file storage and retrieval.
- **Process Management**: Implement multitasking capabilities with process scheduling.
- **Driver Development**: Create drivers for essential hardware components like keyboards, displays, and storage devices.
- **User Interface: Develop a simple shell or graphical interface for user interaction.
- **Networking Capabilities**: Add basic networking support to enable communication between systems.


Happy Coding!
