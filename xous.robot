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

