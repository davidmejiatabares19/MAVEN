package com.ejemplo.clientes;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ClienteController {
    private final ClienteService servicio;
    public ClienteController(ClienteService servicio) { this.servicio = servicio; }

    @GetMapping("/")
    public String inicio(Model model) {
        model.addAttribute("clientes", servicio.listar());
        return "clientes";
    }

    @PostMapping("/clientes")
    public String crear(@RequestParam String cedula,
                        @RequestParam String nombre,
                        @RequestParam String direccion,
                        @RequestParam String telefono,
                        Model model) {
        cedula = cedula.trim(); nombre = nombre.trim();
        direccion = direccion.trim(); telefono = telefono.trim();
        if (cedula.isEmpty() || nombre.isEmpty() || direccion.isEmpty() || telefono.isEmpty()) {
            model.addAttribute("error", "Completa todos los campos para guardar el cliente.");
        } else if (servicio.existeCedula(cedula)) {
            model.addAttribute("error", "Ya existe un cliente registrado con esa cédula.");
        } else {
            servicio.agregar(new Cliente(cedula, nombre, direccion, telefono));
            model.addAttribute("exito", "Cliente registrado correctamente.");
        }
        model.addAttribute("clientes", servicio.listar());
        return "clientes";
    }
}
