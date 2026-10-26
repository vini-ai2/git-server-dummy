## Here's a list of all the things that went wrong
(and my first time encountering all of them)

1. The Git Server initially rejected all the pushes 
    Error: 
    ```
    403
    Service not enabled: 'receive-pack'
    ```
    - We had to enable ``` [http]
                            receivepack = true```
    
2. The hook couldn't detect the first push correctly 
    Error:
    ```
    fatal: bad object 0000000000000000000000000000000000000000
    ```

3. Hex was not automatically updated
    Error: It would flag that the .cpp file ws changed, but the hex file was still the old binary. 
    - This will later be rectified using a bin that collected all these hex files.

4. The HTTP 504 issue

    Error: 
    When git push reached ``` Writing objects: 100% ```  there would be a ``` HTTP 504``` error. First, I thought there was a problem with Nginx. But what actually happened was that while we were waiting for Teensy, nginx eventually timed out, hence the 504. That meant that the teensy was not being detected properly.

    4.1. Loader gave a ``` Unable to claim interface, check USB permissions ``` error
    - THe USB permissions were not set right. Initially, it said ``` crw-rw-r-- 1 root root ..``` which the git user wasn't able to access properrly.
    - A solution to this was to create a ``` /etc/udev/rules.d/00-teensy.rules ``` with permissions of ``` 16c0:0483 → plugdev  16c0:0478 → plugdev```
    
    4.2 Discovering the second Teensy USB mode 

    Normal Teesny would be seen as:
    ``` 
    16c0:0483
    Teensyduino Serial
    ```

    But the bootloader looks like:
    ```
    16c0:0478
    Teensy HalfKay Bootloader
    ```

    And hence, there had to be another rule for udev rule for ``` 16c0:0478 ``` and because HalfKay exposes itsef through HID, we needed 
    ```
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", MODE="0660", GROUP="plugdev"
    ```

    So this helped me achieve ``` crw-rw---- 1 root plugdev ... ``` and most importantly, 

    ```
        READ OK
        WRITE OK
    ```


5. There may be a need to reset sometimees. That needs to be looked into.
