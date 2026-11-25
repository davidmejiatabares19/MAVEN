package com.ejemplo.clientes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class ClienteService {
    private final List<Cliente> clientes = new ArrayList<>();

    public List<Cliente> listar() {
        return Collections.unmodifiableList(new ArrayList<>(clientes));
    }

    public boolean existeCedula(String cedula) {
        return clientes.stream().anyMatch(c -> c.getCedula().equalsIgnoreCase(cedula));
    }

    public void agregar(Cliente cliente) {
        clientes.add(cliente);
    }
}
