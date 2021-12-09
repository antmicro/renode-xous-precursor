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
${FRAME1}                     @onBootScreenshot.png


*** Keywords ***

Create Xous Machine
    Execute Script            ${SCRIPT}
    Create Terminal Tester    ${CONSOLE}    machine=SoC
    Create Terminal Tester    ${EC_UART}    machine=EC
*** Test Cases ***
Should Enter Main Loop On SoC And EC
    Create Xous Machine
    Start Emulation
    Wait For Line On Uart     main loop    testerId=1
    Wait For Line On Uart     status: starting main loop    testerId=0

Should Test FrameBuffer
    Create XousMachine
    Start Emulation
    Execute Command           emulation CreateFrameBufferTester "fb_tester" 5

    Execute Command           mach set 0 
    Execute Command           fb_tester AttachTo memlcd

    Wait For Line On Uart     main loop    testerId=1
    Wait For Line On Uart     status: starting main loop    testerId=0

    Execute Command           fb_tester WaitForFrame ${FRAME1}

