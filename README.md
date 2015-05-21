# architecture
Pipeline processor
## Introduction 
* This is implementation of simplified MIPS (pipeline) microprocessor by VHDL 
* it's academic Project of (Computer Architecture) course

## Specification 
  * Word length 16 bits.
  * Memory size of 2K words.
  * 5 general components: Fetch unit, Decode unit , Excute unit,  Memory Access  and Writeback unit .
  * Handling RAW (read after right) data hazard with forwarding and stall
  * Using harvard architecture (2 memories one for instructions and another for data)
  * When interrupt rise instruction Fetch unit will be flushed ,rest will continue
  * there is stall cycle between push pc and save flags
  * if Pop R3 (sp) Memory value will be in R3 not sp+1 
![specs logo] (https://raw.githubusercontent.com/FawzY93/architecture/master/Images/general-specs.PNG) 

##The CPU support the following instruction set:
### 1. A-Format:
![A-Format logo] (https://raw.githubusercontent.com/FawzY93/architecture/master/Images/A-format.PNG)

### 2. B-Format:
![B-Format Logo] (https://raw.githubusercontent.com/FawzY93/architecture/master/Images/B-format.PNG)

### 3. L-Format:
![L-Format Logo] (https://raw.githubusercontent.com/FawzY93/architecture/master/Images/L-format.PNG)

## Authors
* [Ahmed Kamal Abd El Raouf.](https://github.com/AhmedKamal1432)
* [Mohamed Fawzy Abd El Raouf.](m_fawzy93@hotmail.com)
* [Abdel Rahman Sharbasy]
* [Waleed Nader Hassanen.](waleed.nader93@live.com)
