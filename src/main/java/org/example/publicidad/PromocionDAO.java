package org.example.publicidad;

import java.util.List;

public interface PromocionDAO {

    List<Promocion> listarPromociones();

    List<Promocion> listarPromocionesActivas();

    Promocion obtenerPromocionPorId(int id);

    void crearPromocion(Promocion promocion);

    void actualizarPromocion(Promocion promocion);

    void desactivarPromocion(int id);
}
