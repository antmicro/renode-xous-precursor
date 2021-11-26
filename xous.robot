*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${SCRIPT}                     ${CURDIR}/xous-core/emulation/xous.resc
${CONSOLE}                    sysbus.console

*** Keywords ***

Create Xous Machine
    Execute Script            ${SCRIPT}
    Create Terminal Tester    ${CONSOLE}   SoC
*** Test Cases ***
Should Enter Main Loop
    Create Xous Machine
    Start Emulation
    Wait For Line On Uart     status: starting main loop

