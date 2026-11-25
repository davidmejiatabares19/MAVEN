*** Settings ***
Library    Process

*** Test Cases ***
La pantalla de clientes se muestra correctamente
    ${respuesta}=    Run Process    curl.exe    -fsS    http://127.0.0.1:8081/
    Should Be Equal As Integers    ${respuesta.rc}    0
    Should Contain    ${respuesta.stdout}    Clientes
    Should Contain    ${respuesta.stdout}    Cédula
