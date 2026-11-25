package com.ejemplo.clientes;

public class Cliente {
    private final String cedula;
    private final String nombre;
    private final String direccion;
    private final String telefono;

    public Cliente(String cedula, String nombre, String direccion, String telefono) {
        this.cedula = cedula;
        this.nombre = nombre;
        this.direccion = direccion;
        this.telefono = telefono;
    }
    public String getCedula() { return cedula; }
    public String getNombre() { return nombre; }
    public String getDireccion() { return direccion; }
    public String getTelefono() { return telefono; }
}
