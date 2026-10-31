
package org.example.producto;

import org.example.categoria.Categoria;
import org.example.categoria.CategoriaService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class ProductoServiceImpl implements ProductoService {

    private final ProductoDAO productoDAO;
    private final CategoriaService categoriaService;

    public ProductoServiceImpl(ProductoDAO productoDAO,
                               CategoriaService categoriaService) {
        this.productoDAO = productoDAO;
        this.categoriaService = categoriaService;
    }

    @Override
    public List<Producto> listarProductos() {
        return productoDAO.listarProductos();
    }

    @Override
    public List<Producto> listarProductosActivos() {
        return productoDAO.listarProductosActivos();
    }

    @Override
    public List<Producto> listarParaCatalogo(
            String buscar,
            Integer idCategoria,
            boolean soloDisponibles) {

        String texto = "";

        if (buscar != null) {
            texto = buscar.trim().toLowerCase(Locale.ROOT);
        }

        List<Producto> resultado = new ArrayList<>();

        for (Producto producto : productoDAO.listarProductosActivos()) {
            if (!texto.isEmpty()) {
                String nombreProducto = producto.getNombre();

                if (nombreProducto == null
                        || !nombreProducto.toLowerCase(Locale.ROOT).contains(texto)) {
                    continue;
                }
            }

            if (idCategoria != null && !idCategoria.equals(producto.getIdCategoria())) {
                continue;
            }

            if (soloDisponibles && producto.getStock() <= 0) {
                continue;
            }

            resultado.add(producto);
        }

        return resultado;
    }

    @Override
    public Producto obtenerProductoPorId(int id) {
        return productoDAO.obtenerProductoPorId(id);
    }

    @Override
    public Producto obtenerProductoParaPedido(int id) {
        return productoDAO.obtenerProductoParaPedido(id);
    }

    @Override
    public boolean descontarStock(int idProducto, int cantidad) {
        return productoDAO.descontarStock(idProducto, cantidad);
    }

    @Override
    public int aumentarStock(int idProducto, int cantidad) {
        return productoDAO.aumentarStock(idProducto, cantidad);
    }

    @Override
    public void crearProducto(Producto producto) {
        validarProducto(producto);
        productoDAO.crearProducto(producto);
    }

    @Override
    public void actualizarProducto(Producto producto) {
        validarProducto(producto);

        if (producto.getIdProducto() == null ||
                productoDAO.obtenerProductoPorId(
                        producto.getIdProducto()) == null) {
            throw new IllegalArgumentException(
                    "El producto que desea actualizar no existe"
            );
        }

        productoDAO.actualizarProducto(producto);
    }

    @Override
    public void desactivarProducto(int id) {
        productoDAO.desactivarProducto(id);
    }

    private void validarProducto(Producto producto) {

        String nombre = "";

        if (producto.getNombre() != null) {
            nombre = producto.getNombre().trim();
        }

        if (nombre.isEmpty()) {
            throw new IllegalArgumentException(
                    "El nombre del producto es obligatorio"
            );
        }

        for (Producto existente : productoDAO.listarProductos()) {
            if (existente.getNombre() == null) {
                continue;
            }

            boolean mismoNombre = existente.getNombre().trim().equalsIgnoreCase(nombre);
            boolean esOtro = producto.getIdProducto() == null
                    || !producto.getIdProducto().equals(existente.getIdProducto());

            if (mismoNombre && esOtro) {
                throw new IllegalArgumentException(
                        "Ya existe un producto con ese nombre"
                );
            }
        }

        producto.setNombre(nombre);

        if (producto.getPrecio() == null ||
                producto.getPrecio().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException(
                    "El precio debe ser mayor que cero"
            );
        }

        if (producto.getStock() < 0) {
            throw new IllegalArgumentException(
                    "El stock no puede ser negativo"
            );
        }

        if (producto.getIdCategoria() == null) {
            throw new IllegalArgumentException(
                    "Debe seleccionar una categoría"
            );
        }

        Categoria categoria = categoriaService.obtenerCategoriaPorId(
                producto.getIdCategoria()
        );

        if (categoria == null || !categoria.isEstado()) {
            throw new IllegalArgumentException(
                    "La categoría seleccionada no existe o está inactiva"
            );
        }
    }
}
