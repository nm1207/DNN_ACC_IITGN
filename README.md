# Project Title: Floating Point Hardware Accelerators for Deep Neural Networks (DNNs)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

## Overview

Welcome to the DNN Accelerators repository! This project is a collaborative effort led by the team at IITGN and aims to design and develop DNN (Deep Neural Network) accelerators for Caravel Tapeout. Our goal is to create efficient hardware accelerators capable of offloading DNN workloads, supporting various numerical representations, and ultimately enhancing system performance without sacrificing accuracy.

## Project Description

### Design Idea

The rapid advancement of Deep Neural Network (DNN) models has led to increasingly complex and resource-intensive workloads. These models demand significant computational power, which can pose challenges in terms of memory usage and power consumption when executed on general-purpose compute cores. To address these challenges, DNN accelerator architectures have emerged as a promising solution.

Our project revolves around the idea of designing a System on Chip (SoC) that includes the following key components:

- **Simba Accelerator**: This accelerator is designed to efficiently handle DNN workloads, making use of optimized hardware for various mathematical computations.

- **Gemmini Accelerator**: Gemmini is another dedicated accelerator aimed at accelerating DNN tasks, providing support for Integer, Posit, Fixed Posit, and Floating Point (FP) MAC (Multiply-Accumulate) computations.

- **Shared Global Buffer/Reg File**: To facilitate data sharing and efficient communication between the accelerators and other components of the SoC, we implement a shared global buffer and register file.

- **Controller**: The controller unit manages the overall operation of the SoC, coordinating tasks between the accelerators and external interfaces.

- **IO Interfaces**: We provide interfaces to connect the SoC with external devices and systems, ensuring seamless data transfer and communication.

### Motivation

The motivation behind this project is the increasing demand for efficient DNN acceleration solutions. As DNN models become more complex, there is a growing need for specialized hardware that can execute these workloads swiftly and power-efficiently. We believe that by offering support for multiple numerical representations, such as Posit and Fixed Posit, we can significantly enhance system performance without compromising accuracy.

## Getting Started

To get started with our DNN Accelerators project, please refer to the following resources:

- **Quickstart**: For a step-by-step guide on how to use the caravel_user_project, consult the [README](docs/source/index.rst#section-quickstart).

- **Documentation**: Comprehensive documentation for this sample project can be found in the [README](docs/source/index.rst). It provides detailed information on project setup, configuration, and usage.

- **Cocotb Tests**: If you're interested in adding cocotb tests to your project, you can explore the documentation available on [readthedocs](https://caravel-sim-infrastructure.readthedocs.io/en/latest/index.html).

## Important Note

We are excited about the potential impact of our DNN accelerators and are dedicated to continuously improving and expanding this project. Your contributions and feedback are highly encouraged and welcome. Together, we can push the boundaries of DNN acceleration and make strides in enhancing computational efficiency for deep learning workloads. Thank you for joining us on this journey!

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

