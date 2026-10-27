package org.example.pedido;

import org.example.carrito.ItemCarrito;
import org.example.usuario.Usuario;
import org.example.usuario.UsuarioDAO;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.example.producto.ProductoDAO;
import org.example.producto.Producto;

import java.math.BigDecimal;
import java.time.Year;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Service
public class PedidoServiceImpl implements PedidoService {

    private final PedidoDAO pedidoDAO;
    private final UsuarioDAO usuarioDAO;
    private final ProductoDAO productoDAO;

    public PedidoServiceImpl(
            PedidoDAO pedidoDAO,
            UsuarioDAO usuarioDAO,
            ProductoDAO productoDAO ) {

        this.pedidoDAO = pedidoDAO;
        this.usuarioDAO = usuarioDAO;
        this.productoDAO = productoDAO;
    }

    @Override
    @Transactional
    public int confirmarPedido(
            int idUsuario,
            String direccionEntrega,
            String telefono,
            String medioPago,
            List<ItemCarrito> carrito) {

        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(idUsuario);

        if (usuario == null || !usuario.isEstado()) {
            throw new IllegalArgumentException(
                    "El usuario no existe o está inactivo"
            );
        }

        if (direccionEntrega == null ||
                direccionEntrega.isBlank() ||
                direccionEntrega.trim().length() > 255) {

            throw new IllegalArgumentException(
                    "Ingrese una dirección de entrega válida"
            );
        }

        if (telefono == null ||
                !telefono.matches("9[0-9]{8}")) {

            throw new IllegalArgumentException(
                    "Ingrese un celular válido de 9 dígitos"
            );
        }

        if (medioPago == null ||
                !Set.of("YAPE", "PLIN", "TARJETA").contains(medioPago)) {

            throw new IllegalArgumentException(
                    "Seleccione un medio de pago válido: Yape, Plin o Tarjeta"
            );
        }

        if (carrito == null || carrito.isEmpty()) {
            throw new IllegalArgumentException(
                    "El carrito está vacío"
            );
        }

        BigDecimal total = BigDecimal.ZERO;

        Set<Integer> productosProcesados = new HashSet<>();
        List<DetallePedido> detalles = new ArrayList<>();

        for (ItemCarrito item : carrito) {

            if (item == null || item.getProducto() == null) {
                throw new IllegalArgumentException(
                        "Hay un producto inválido en el carrito"
                );
            }

            int idProducto = item.getProducto().getIdProducto();
            int cantidad = item.getCantidad();

            if (idProducto <= 0 || cantidad <= 0) {
                throw new IllegalArgumentException(
                        "El producto o la cantidad no son válidos"
                );
            }

            if (!productosProcesados.add(idProducto)) {
                throw new IllegalArgumentException(
                        "El carrito contiene productos repetidos"
                );
            }

            Producto producto =
                    productoDAO.obtenerProductoParaPedido(idProducto);

            if (producto == null) {
                throw new IllegalArgumentException(
                        "Uno de los productos ya no existe"
                );
            }

            if (!producto.isEstado()) {
                throw new IllegalArgumentException(
                        "Uno de los productos no está disponible"
                );
            }

            if (producto.getPrecio() == null ||
                    producto.getPrecio().compareTo(BigDecimal.ZERO) <= 0) {

                throw new IllegalArgumentException(
                        "Uno de los productos tiene un precio inválido"
                );
            }

            if (producto.getStock() < cantidad) {
                throw new IllegalArgumentException(
                        "Stock insuficiente para el producto " + idProducto
                );
            }

            BigDecimal subtotal = producto.getPrecio().multiply(
                    BigDecimal.valueOf(cantidad)
            );

            DetallePedido detalle = new DetallePedido();

            detalle.setIdProducto(idProducto);
            detalle.setCantidad(cantidad);
            detalle.setPrecioUnitario(producto.getPrecio());
            detalle.setSubtotal(subtotal);

            detalles.add(detalle);
            total = total.add(subtotal);
        }

        Pedido pedido = new Pedido();

        pedido.setIdUsuario(idUsuario);
        pedido.setDireccionEntrega(direccionEntrega.trim());
        pedido.setTelefono(telefono);
        pedido.setTotal(total);
        pedido.setEstado("RECIBIDO");
        pedido.setMedioPago(medioPago);
        pedido.setIdRepartidor(null);
        pedido.setCodigoSeguimiento(generarCodigoSeguimiento());

        int idPedido = pedidoDAO.registrarPedido(pedido);

        if (idPedido <= 0) {
            throw new IllegalStateException(
                    "No se pudo registrar el pedido"
            );
        }

        for (DetallePedido detalle : detalles) {

            detalle.setIdPedido(idPedido);

            pedidoDAO.registrarDetalle(detalle);

            boolean stockActualizado = productoDAO.descontarStock(
                    detalle.getIdProducto(),
                    detalle.getCantidad()
            );

            if (!stockActualizado) {
                throw new IllegalStateException(
                        "No se pudo actualizar el stock del producto "
                                + detalle.getIdProducto()
                );
            }
        }

        return idPedido;
    }

    @Override
    public Pedido obtenerPedidoPorId(int idPedido) {
        return pedidoDAO.obtenerPedidoPorId(idPedido);
    }

    @Override
    public List<Pedido> listarPedidosPorUsuario(int idUsuario) {
        return pedidoDAO.listarPedidosPorUsuario(idUsuario);
    }

    @Override
    public List<DetallePedido> listarDetallesPorPedido(int idPedido) {
        return pedidoDAO.listarDetallesPorPedido(idPedido);
    }

    @Override
    public List<DetallePedido> listarTodosLosDetalles() {
        return pedidoDAO.listarTodosLosDetalles();
    }

    @Override
    public List<Pedido> listarTodosLosPedidos() {
        return pedidoDAO.listarTodosLosPedidos();
    }

    @Override
    @Transactional
    public void actualizarEstadoPedido(
            int idPedido,
            String nuevoEstado) {

        if (idPedido <= 0) {
            throw new IllegalArgumentException(
                    "El ID del pedido no es válido"
            );
        }

        if (nuevoEstado == null || nuevoEstado.isBlank()) {
            throw new IllegalArgumentException(
                    "Debe seleccionar un estado"
            );
        }

        String estadoActual =
                pedidoDAO.obtenerEstadoBloqueado(idPedido);

        if (estadoActual == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe"
            );
        }

        boolean transicionPermitida =
                ("RECIBIDO".equals(estadoActual)
                        && "EN PREPARACIÓN".equals(nuevoEstado))
                        ||
                        ("EN PREPARACIÓN".equals(estadoActual)
                                && "LISTO".equals(nuevoEstado));

        if (!transicionPermitida) {
            throw new IllegalArgumentException(
                    "Transición no permitida. " +
                            "Solo se permite RECIBIDO a EN PREPARACIÓN " +
                            "y EN PREPARACIÓN a LISTO."
            );
        }

        int filasActualizadas =
                pedidoDAO.actualizarEstadoPedido(
                        idPedido,
                        estadoActual,
                        nuevoEstado
                );

        if (filasActualizadas != 1) {
            throw new IllegalStateException(
                    "El estado del pedido cambió. Intenta nuevamente."
            );
        }
    }

    @Override
    public Pedido obtenerPedidoPorCodigoSeguimiento(
            String codigoSeguimiento) {

        if (codigoSeguimiento == null ||
                codigoSeguimiento.isBlank()) {

            throw new IllegalArgumentException(
                    "Ingrese un código de seguimiento válido"
            );
        }

        String codigo = codigoSeguimiento.trim()
                .toUpperCase(Locale.ROOT);

        if (!codigo.matches("PAS-[0-9]{4}-[A-F0-9]{16}")) {
            throw new IllegalArgumentException(
                    "Formato de código de seguimiento inválido"
            );
        }

        return pedidoDAO.obtenerPedidoPorCodigoSeguimiento(codigo);
    }

    @Override
    @Transactional
    public void cancelarPedido(
            int idPedido,
            int idUsuario) {

        if (idPedido <= 0 || idUsuario <= 0) {
            throw new IllegalArgumentException(
                    "Los datos del pedido o usuario no son válidos"
            );
        }

        Pedido pedido =
                pedidoDAO.obtenerDatosCancelacionBloqueado(idPedido);

        if (pedido == null) {
            throw new IllegalArgumentException(
                    "El pedido no existe"
            );
        }

        if (pedido.getIdUsuario() == null
                || pedido.getIdUsuario().intValue() != idUsuario) {
            throw new IllegalArgumentException(
                    "No tienes permiso para cancelar este pedido"
            );
        }

        if (!"RECIBIDO".equals(pedido.getEstado())) {
            throw new IllegalArgumentException(
                    "Solo puedes cancelar pedidos RECIBIDOS"
            );
        }

        List<DetallePedido> detalles =
                pedidoDAO.listarDetallesPorPedido(idPedido);

        if (detalles == null || detalles.isEmpty()) {
            throw new IllegalStateException(
                    "El pedido no tiene productos registrados"
            );
        }

        int pedidosActualizados =
                pedidoDAO.cancelarPedido(idPedido, idUsuario);

        if (pedidosActualizados != 1) {
            throw new IllegalStateException(
                    "No se pudo cancelar el pedido"
            );
        }

        for (DetallePedido detalle : detalles) {

            if (detalle.getCantidad() <= 0) {
                throw new IllegalStateException(
                        "El pedido contiene una cantidad inválida"
                );
            }

            int productosActualizados =
                    productoDAO.aumentarStock(
                            detalle.getIdProducto(),
                            detalle.getCantidad()
                    );

            if (productosActualizados != 1) {
                throw new IllegalStateException(
                        "No se pudo devolver el stock del producto "
                                + detalle.getIdProducto()
                );
            }
        }
    }

    @Override
    @Transactional
    public int registrarVentaEnTienda(
            String telefono,
            String medioPago,
            List<Integer> idProductos,
            List<Integer> cantidades) {

        if (telefono == null || !telefono.matches("9[0-9]{8}")) {
            throw new IllegalArgumentException(
                    "Ingrese un celular válido de 9 dígitos"
            );
        }

        if (medioPago == null ||
                !Set.of("EFECTIVO", "YAPE", "PLIN", "TARJETA").contains(medioPago)) {
            throw new IllegalArgumentException(
                    "Seleccione un medio de pago válido"
            );
        }

        if (idProductos == null || cantidades == null
                || idProductos.size() != cantidades.size()) {
            throw new IllegalArgumentException(
                    "Los productos de la venta no son válidos"
            );
        }

        Usuario mostrador = usuarioDAO.buscarPorCorreo("mostrador@pasteleria.com");

        if (mostrador == null || !mostrador.isEstado()) {
            throw new IllegalStateException(
                    "No existe el usuario de mostrador"
            );
        }

        List<DetallePedido> detalles = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        for (int i = 0; i < idProductos.size(); i++) {
            Integer cantidad = cantidades.get(i);

            if (cantidad == null || cantidad <= 0) {
                continue;
            }

            Producto producto = productoDAO.obtenerProductoPorId(idProductos.get(i));

            if (producto == null || !producto.isEstado()) {
                throw new IllegalArgumentException(
                        "Uno de los productos no está disponible"
                );
            }

            if (producto.getStock() < cantidad) {
                throw new IllegalArgumentException(
                        "Stock insuficiente para " + producto.getNombre()
                );
            }

            BigDecimal subtotal = producto.getPrecio()
                    .multiply(BigDecimal.valueOf(cantidad));

            DetallePedido detalle = new DetallePedido();
            detalle.setIdProducto(producto.getIdProducto());
            detalle.setCantidad(cantidad);
            detalle.setPrecioUnitario(producto.getPrecio());
            detalle.setSubtotal(subtotal);

            detalles.add(detalle);
            total = total.add(subtotal);
        }

        if (detalles.isEmpty()) {
            throw new IllegalArgumentException(
                    "Indique la cantidad de al menos un producto"
            );
        }

        Pedido pedido = new Pedido();
        pedido.setIdUsuario(mostrador.getIdUsuario());
        pedido.setDireccionEntrega("Recojo en tienda");
        pedido.setTelefono(telefono);
        pedido.setTotal(total);
        pedido.setEstado("ENTREGADO");
        pedido.setMedioPago(medioPago);
        pedido.setIdRepartidor(null);
        pedido.setCodigoSeguimiento(generarCodigoSeguimiento());

        int idPedido = pedidoDAO.registrarPedido(pedido);
        pedidoDAO.registrarFechaEntrega(idPedido);

        for (DetallePedido detalle : detalles) {
            detalle.setIdPedido(idPedido);
            pedidoDAO.registrarDetalle(detalle);

            boolean stockActualizado = productoDAO.descontarStock(
                    detalle.getIdProducto(),
                    detalle.getCantidad()
            );

            if (!stockActualizado) {
                throw new IllegalStateException(
                        "No se pudo actualizar el stock del producto "
                                + detalle.getIdProducto()
                );
            }
        }

        return idPedido;
    }

    @Override
    public List<Integer> leerCantidades(List<String> cantidad) {
        List<Integer> cantidades = new ArrayList<>();

        if (cantidad == null) {
            return cantidades;
        }

        for (String valor : cantidad) {
            if (valor == null || valor.isBlank()) {
                cantidades.add(0);
                continue;
            }

            try {
                cantidades.add(Integer.parseInt(valor.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException(
                        "La cantidad debe ser un número entero"
                );
            }
        }

        return cantidades;
    }

    @Override
    public Map<String, List<Pedido>> agruparPorEstado(List<Pedido> pedidos) {
        Map<String, List<Pedido>> bloques = new LinkedHashMap<>();

        bloques.put("RECIBIDO", new ArrayList<>());
        bloques.put("EN PREPARACIÓN", new ArrayList<>());
        bloques.put("LISTO", new ArrayList<>());
        bloques.put("ASIGNADO", new ArrayList<>());
        bloques.put("EN CAMINO", new ArrayList<>());
        bloques.put("ENTREGADO", new ArrayList<>());
        bloques.put("CANCELADO", new ArrayList<>());

        for (Pedido pedido : pedidos) {
            List<Pedido> bloque = bloques.get(pedido.getEstado());

            if (bloque != null) {
                bloque.add(pedido);
            }
        }

        return bloques;
    }

    @Override
    public Map<Integer, String> nombresDeClientes(List<Pedido> pedidos) {
        Map<Integer, String> nombres = new HashMap<>();

        for (Pedido pedido : pedidos) {
            Integer idCliente = pedido.getIdUsuario();

            if (idCliente == null || nombres.containsKey(idCliente)) {
                continue;
            }

            Usuario cliente = usuarioDAO.obtenerUsuarioPorId(idCliente);

            if (cliente == null) {
                nombres.put(idCliente, "Cliente no encontrado");
            } else if ("mostrador@pasteleria.com".equals(cliente.getCorreo())) {
                nombres.put(idCliente, "Venta en tienda");
            } else {
                nombres.put(idCliente, cliente.getNombres() + " " + cliente.getApellidos());
            }
        }

        return nombres;
    }

    @Override
    public Map<Integer, String> resumirProductos() {
        Map<Integer, StringBuilder> textos = new LinkedHashMap<>();

        for (DetallePedido detalle : listarTodosLosDetalles()) {
            String nombre = detalle.getNombreProducto();

            if (nombre == null || nombre.isBlank()) {
                nombre = "Producto sin nombre";
            }

            StringBuilder texto = textos.computeIfAbsent(
                    detalle.getIdPedido(),
                    id -> new StringBuilder()
            );

            if (!texto.isEmpty()) {
                texto.append(", ");
            }

            texto.append(nombre)
                    .append(" x ")
                    .append(detalle.getCantidad());
        }

        Map<Integer, String> resumen = new HashMap<>();

        for (Map.Entry<Integer, StringBuilder> entrada : textos.entrySet()) {
            resumen.put(entrada.getKey(), entrada.getValue().toString());
        }

        return resumen;
    }

    @Override
    public Map<String, Long> contarPorEstado(List<Pedido> pedidos) {
        Map<String, Long> conteo = new LinkedHashMap<>();

        for (List<Pedido> bloque : agruparPorEstado(pedidos).values()) {
            if (!bloque.isEmpty()) {
                conteo.put(bloque.get(0).getEstado(), (long) bloque.size());
            }
        }

        conteo.putIfAbsent("RECIBIDO", 0L);
        conteo.putIfAbsent("EN PREPARACIÓN", 0L);
        conteo.putIfAbsent("LISTO", 0L);
        conteo.putIfAbsent("ASIGNADO", 0L);
        conteo.putIfAbsent("EN CAMINO", 0L);
        conteo.putIfAbsent("ENTREGADO", 0L);
        conteo.putIfAbsent("CANCELADO", 0L);

        return conteo;
    }

    private String generarCodigoSeguimiento() {

        return "PAS-" + Year.now().getValue() + "-" +
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 16)
                        .toUpperCase(Locale.ROOT);
    }

}
