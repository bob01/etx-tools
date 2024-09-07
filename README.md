[![GitHub license](https://img.shields.io/github/license/bob01/etxwidgets)](https://github.com/bob01/etxwidgets/main/LICENSE)


# Welcome to etx-Tools for EdgeTX
**ESC configuration apps for RotorFlight v2+ when used with an ESC supporting bi-directional telemetry**<br>Thanks to Mike W. and Diego A. for the endless hours of testing.

** USE AT YOUR OWN RISK **
###
![image](https://github.com/bob01/etx-tools/assets/4014433/0f000de7-31b1-4503-ae66-3a3b108e9111)


### Requirements
- Supported ESC
   - YGE
   - Scorpion
   - HobbyWing v5
- RF2 master branch (change was too big to make it into RotorFlight 2.0 release)

### Half Duplex mode
- most ESCs use 3 wire telemetry cables with 1 signal wire and require one-wire (half-duplex) for bidirectional telemetry
- what this means...
  1) half-duplex mode requires the ESC to be connected to the TX pin (vs RX) of the RotorFlight flight controller
     - modify the telemetry cable OR...
     - resource remapping the serial port pins e.g. for the following controllers, using the CLI<br>
       This is preferred as it easier and avoids using non standard cables, plus some flight controls have only 3 pin ports.
       - FlyDragon F722 v2 w/ ESC conected to EXT (serial 3)
         - \# resources<br>
           resource SERIAL_RX 3 NONE<br>
           resource SERIAL_TX 3 C11
       - RadioMaster NEXUS
         - \# resources<br>
           resource SERIAL_RX 1 NONE<br>
           resource SERIAL_TX 1 A10
  2) enable hald-duplex mode for ESC sensor
      - \# master<br>
      set esc_sensor_halfduplex = ON

### Supported ESCs
- YGE and Scorpion have been in general use locally for some time and are considered mature
- HW v5 is now available
- others in the works


### YGE support
- configure FC and ESC telemetry protocol as "OpenYGE"
- requires ESC firmware 1.03551 or later
- ESC can be configured at any time, no restart required e.g.
   - bench setup or adjustments in the pits
   - flight-line adjustments of internal governor PIDs etc.<br>Land. Adjust. Fly. Repeat.

![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/1a311e7e-ed82-4eab-8c6b-27d0efddfcad)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/c045a598-e225-4996-888b-1f43eb4ea8fd)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/b31d914a-893c-41f7-9c8b-cad843efa8bc)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/7ebeab4a-6f50-4212-b96f-b1a2651a2224)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/ed93d483-fa10-446d-ac50-41dc3366c8ad)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/11915e6c-06a6-4553-9d27-e6d2cfbbe691)


### Scorpion support
- configure FC and ESC telemetry protocol as 'UNC'
- requires Tribunus ESC firmware v63 or later
- ESC waits for ~ 10 seconds after power on after which telemetry data stream starts and ESC will not respond to telemetry commands until restarted
- ESC must be restarted for changes to take effect and for telemetry to resume, 'Restart ESC' menu option available
- user must open app AND enter one of the configuration pages ASAP after connecting the power ie suitable for...
   - bench setup or adjustments in the pits

![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/a81ade56-de92-478d-b61f-bffad735fcf0)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/51016168-bc81-4680-9fba-c1ddd990472a)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/fdade425-e0e1-49c3-ac7d-fe60a8f64970)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/69c12389-5eef-45b0-836a-f146e4c38f34)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/51296082-9f9e-4c03-a249-68e17e29a0f1)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/2fd43236-c876-4983-9fdb-e389b7742204)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/5e09caed-e315-44c3-85f2-30682413099b)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/809cadac-b275-41f4-8a38-bfaf3baee006)
![image](https://github.com/rotorflight/rotorflight-firmware/assets/4014433/c98960c5-ae22-4604-aa11-85d9d537ece8)



### HobbyWing support
- configure FC as 'HobbyWing v5'
- requires Platinum 5 ESC, tested with PL-04.0.11 and current version PL-04.1.02
- ESC can be configured at any time, restart required - ESC must be power-cycled e.g.
   - bench setup or adjustments in the pits
   - \*\* 'Restart ESC' menu option may appear in the future.<br>This would allow flight-line adjustments if using a buffer pack / capacitor bank etc.
 
![image](https://github.com/bob01/etx-tools/assets/4014433/b727b4ce-75dc-4cf8-9965-19aec3bf1f70)
![image](https://github.com/bob01/etx-tools/assets/4014433/997232a0-6fa8-49f1-ae17-a096016cc8a4)
![image](https://github.com/bob01/etx-tools/assets/4014433/12a27925-0e76-45e5-a296-bf3177b1f8f9)
![image](https://github.com/bob01/etx-tools/assets/4014433/1f886098-0e5d-4a47-a58c-40b9f96eaedf)
![image](https://github.com/bob01/etx-tools/assets/4014433/b3125f87-88ae-4756-8abc-4c420a0afcaa)
![image](https://github.com/bob01/etx-tools/assets/4014433/2980b767-cd56-4446-aa22-60eaecb3a32a)
![image](https://github.com/bob01/etx-tools/assets/4014433/028ebd5c-f606-4496-a58a-db9d6775f8a1)
