*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${SCRIPT}                     ${CURDIR}/xous.resc
${CONSOLE}                    sysbus.console
${EC_UART}                    sysbus.uart

${BOOT_FRAME}                 @${CURDIR}/screenshots/pddb-format.png
${STATUS_BAR}                 @${CURDIR}/screenshots/status-bar.png
${HELP_RESULT}                @${CURDIR}/screenshots/help.png
${VER_EC}                     @${CURDIR}/screenshots/ver-ec.png
${MENU_SCREEN}                @${CURDIR}/screenshots/popup.png

*** Keywords ***
Create Xous Machine
    Execute Script            ${SCRIPT}
    Create Terminal Tester    ${CONSOLE}    machine=SoC
    Create Terminal Tester    ${EC_UART}    machine=EC

Home
    Execute Command           keyboard InjectKey 0x1b
    Execute Command           keyboard InjectKey 0x5b
    Execute Command           keyboard InjectKey 0x31
    Execute Command           keyboard InjectKey 0x7e

Arrow Up
    Execute Command           keyboard InjectKey 0x1b
    Execute Command           keyboard InjectKey 0x5b
    Execute Command           keyboard InjectKey 0x41

Arrow Down
    Execute Command           keyboard InjectKey 0x1b
    Execute Command           keyboard InjectKey 0x5b
    Execute Command           keyboard InjectKey 0x42


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
# Cancel PDDB formatting
    Arrow Down
    Execute Command           keyboard InjectLine ""
    Arrow Down
    Execute Command           keyboard InjectLine ""

    Execute Command           fb_tester WaitForFrame ${STATUS_BAR}

    Execute Command           keyboard InjectLine "help"
    Execute Command           fb_tester WaitForFrame ${HELP_RESULT}

    Execute Command           keyboard InjectLine "ver ec"
    Execute Command           fb_tester WaitForFrame ${VER_EC}

    Home
    Execute Command           fb_tester WaitForFrame ${MENU_SCREEN}

