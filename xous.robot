*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${SCRIPT}                     ${CURDIR}/xous-core/emulation/xous-test.resc
${CONSOLE}                    sysbus.console
${EC_UART}                    sysbus.uart
${BOOT_FRAME}                 @screenshots/onBootScreenshot.png
${WRITE_FRAME}                @screenshots/echoScreenshot.png  
${EXECUTE_FRAME}              @screenshots/echoResultScreenshot.png  

*** Keywords ***
Create Xous Machine
    Execute Script            ${SCRIPT}
    Create Terminal Tester    ${CONSOLE}    machine=SoC
    Create Terminal Tester    ${EC_UART}    machine=EC

Write Example Text On Memlcd
    #For now, there is no better way to write a string using keyboard model used here.
    #That's why we decided to send the message letter by letter by writing values into UART_CHAR register.
    #Text written here is "echo cat".
    Execute Command           mach set 0
    Execute Command           keyboard WriteDoubleWord 0 101
    Execute Command           keyboard WriteDoubleWord 0 99
    Execute Command           keyboard WriteDoubleWord 0 104
    Execute Command           keyboard WriteDoubleWord 0 111
    Execute Command           keyboard WriteDoubleWord 0 32
    Execute Command           keyboard WriteDoubleWord 0 99
    Execute Command           keyboard WriteDoubleWord 0 97
    Execute Command           keyboard WriteDoubleWord 0 116

*** Test Cases ***
Should Enter Main Loop On SoC And EC
    Create Xous Machine
    Start Emulation
    Wait For Line On Uart     main loop    testerId=1
    Wait For Line On Uart     status: starting main loop    testerId=0

Should Test FrameBuffer
    Create XousMachine
    Start Emulation
    Execute Command           emulation CreateFrameBufferTester "fb_tester" 20 

    Execute Command           mach set 0 
    Execute Command           fb_tester AttachTo memlcd

    Wait For Line On Uart     main loop    testerId=1
    Wait For Line On Uart     status: starting main loop    testerId=0

    Execute Command           fb_tester WaitForFrame ${BOOT_FRAME}
    Write Example Text On Memlcd
    Execute Command           fb_tester WaitForFrame ${WRITE_FRAME}
    #We write carriage return character to execute written command.
    Execute Command           keyboard WriteDoubleWord 0 13 
    Execute Command           fb_tester WaitForFrame ${EXECUTE_FRAME}
    

