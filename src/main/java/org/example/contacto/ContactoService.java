
package org.example.contacto;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
public class ContactoService {

    private final ContactoRepository contactoRepository;

    public ContactoService(ContactoRepository contactoRepository) {
        this.contactoRepository = contactoRepository;
    }

    public void guardarMensaje(
            String nombre,
            String correo,
            String asunto,
            String mensaje) {

        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException(
                    "El nombre es obligatorio."
            );
        }

        if (correo == null ||
                !correo.trim().matches(
                        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            throw new IllegalArgumentException(
                    "Ingresa un correo válido."
            );
        }

        if (asunto == null || asunto.isBlank()) {
            throw new IllegalArgumentException(
                    "Selecciona un asunto."
            );
        }

        if (mensaje == null || mensaje.isBlank()) {
            throw new IllegalArgumentException(
                    "El mensaje no puede estar vacío."
            );
        }

        if (nombre.trim().length() > 100 ||
                correo.trim().length() > 150 ||
                asunto.trim().length() > 100 ||
                mensaje.trim().length() > 2000) {
            throw new IllegalArgumentException(
                    "Uno de los campos supera el límite permitido."
            );
        }

        contactoRepository.guardarMensaje(
                nombre.trim(),
                correo.trim().toLowerCase(Locale.ROOT),
                asunto.trim(),
                mensaje.trim()
        );
    }

    public List<Contacto> listarMensajes() {
        return contactoRepository.listarMensajes();
    }
}
