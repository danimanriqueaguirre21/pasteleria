package org.example.publicidad;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PromocionServiceImpl implements PromocionService {

    private final PromocionDAO promocionDAO;

    public PromocionServiceImpl(PromocionDAO promocionDAO) {
        this.promocionDAO = promocionDAO;
    }

    @Override
    public List<Promocion> listarPromociones() {
        return promocionDAO.listarPromociones();
    }

    @Override
    public List<Promocion> listarPromocionesActivas() {
        return promocionDAO.listarPromocionesActivas();
    }

    @Override
    public Promocion obtenerPromocionPorId(int id) {
        return promocionDAO.obtenerPromocionPorId(id);
    }

    @Override
    public void crearPromocion(Promocion promocion) {
        preparar(promocion);
        promocionDAO.crearPromocion(promocion);
    }

    @Override
    public void actualizarPromocion(Promocion promocion) {
        preparar(promocion);
        promocionDAO.actualizarPromocion(promocion);
    }

    @Override
    public void desactivarPromocion(int id) {
        promocionDAO.desactivarPromocion(id);
    }

    private void preparar(Promocion promocion) {
        String titulo = promocion.getTitulo() == null
                ? ""
                : promocion.getTitulo().trim();

        if (titulo.isEmpty() || titulo.length() > 100) {
            throw new IllegalArgumentException(
                    "El título de la promoción es obligatorio"
            );
        }

        String descripcion = promocion.getDescripcion() == null
                ? ""
                : promocion.getDescripcion().trim();

        if (descripcion.length() > 255) {
            throw new IllegalArgumentException(
                    "La descripción no puede pasar de 255 caracteres"
            );
        }

        String imagen = promocion.getImagen() == null
                ? ""
                : promocion.getImagen().trim();

        if (!imagen.isEmpty() && !imagen.matches("[A-Za-z0-9._-]+")) {
            throw new IllegalArgumentException(
                    "Escribe solo el nombre del archivo, por ejemplo promo-pasteleria.jpg"
            );
        }

        promocion.setTitulo(titulo);
        promocion.setDescripcion(descripcion.isEmpty() ? null : descripcion);
        promocion.setImagen(imagen.isEmpty() ? null : imagen);
    }
}
