# Assembly Line Simulation in Ada

This project is a simulation of an assembly line where products are produced, assembled into various dishes, and consumed by consumers. The assembly line consists of producers, a buffer, and consumers.

## Authors

- [R-Ohman](https://github.com/R-Ohman)
- [vetall7](https://github.com/vetall7)

## Description

The assembly line simulation is implemented in Ada. It consists of the following components:

### Producers

Producers are responsible for producing specific products. They operate asynchronously, producing products according to a given production time.

### Consumers

Consumers consume assembled dishes from the buffer. They operate asynchronously and consume dishes according to a given consumption time.

### Buffer

The buffer acts as a storage area for products and assembled dishes. It facilitates the communication between producers and consumers, ensuring that products are available for assembly and consumption.

## Features

- Asynchronous operation of producers and consumers.
- Dynamic allocation of storage space based on assembly requirements.
- Randomized production and consumption times for realistic simulation.

## Usage

To run the simulation, compile the Ada code and execute the resulting binary.

```bash
gnatmake *.adb
./simulation
```
