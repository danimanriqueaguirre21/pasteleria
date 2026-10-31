package org.example.estadistica;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

@Repository
public class EstadisticaRepository implements EstadisticaDAO {

    private final JdbcTemplate jdbcTemplate;

    public EstadisticaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Map<LocalDate, BigDecimal> obtenerVentasDiarias() {
        return agruparDecimales("""
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    SUM(total) AS total_ventas
                FROM pedido
                WHERE estado <> 'CANCELADO'
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """, "total_ventas");
    }

    @Override
    public Map<LocalDate, Integer> obtenerPedidosPorDia() {
        return agruparEnteros("""
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    COUNT(*) AS total_pedidos
                FROM pedido
                WHERE estado <> 'CANCELADO'
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """, "total_pedidos");
    }

    @Override
    public Map<LocalDate, Integer> obtenerEntregasPorDia() {
        return agruparEnteros("""
                SELECT
                    CAST(fecha_entrega AS DATE) AS fecha,
                    COUNT(*) AS total_entregas
                FROM pedido
                WHERE estado = 'ENTREGADO'
                  AND fecha_entrega IS NOT NULL
                GROUP BY CAST(fecha_entrega AS DATE)
                ORDER BY fecha ASC
                """, "total_entregas");
    }

    @Override
    public Map<LocalDate, BigDecimal> obtenerTicketPromedioPorDia() {
        return agruparDecimales("""
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    CAST(
                        ROUND(AVG(total), 2)
                        AS DECIMAL(15, 2)
                    ) AS ticket_promedio
                FROM pedido
                WHERE estado <> 'CANCELADO'
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """, "ticket_promedio");
    }

    @Override
    public Map<LocalDate, Integer> obtenerUnidadesVendidasPorDia() {
        return agruparEnteros("""
                SELECT
                    CAST(p.fecha_pedido AS DATE) AS fecha,
                    SUM(d.cantidad) AS total_unidades
                FROM pedido p
                INNER JOIN detalle_pedido d
                    ON p.id_pedido = d.id_pedido
                WHERE p.estado <> 'CANCELADO'
                GROUP BY CAST(p.fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """, "total_unidades");
    }

    @Override
    public BigDecimal obtenerImporteTotal() {
        String sql = """
                SELECT COALESCE(SUM(total), 0)
                FROM pedido
                WHERE estado <> 'CANCELADO'
                """;

        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    @Override
    public int obtenerTotalPedidos() {
        String sql = """
                SELECT COUNT(*)
                FROM pedido
                WHERE estado <> 'CANCELADO'
                """;

        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    @Override
    public int obtenerTotalEntregados() {
        String sql = """
                SELECT COUNT(*)
                FROM pedido
                WHERE estado = 'ENTREGADO'
                """;

        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    @Override
    public BigDecimal obtenerTicketPromedioGeneral() {
        String sql = """
                SELECT
                    COALESCE(
                        CAST(
                            ROUND(AVG(total), 2)
                            AS DECIMAL(15, 2)
                        ),
                        0
                    )
                FROM pedido
                WHERE estado <> 'CANCELADO'
                """;

        return jdbcTemplate.queryForObject(sql, BigDecimal.class);
    }

    @Override
    public int obtenerTotalUnidades() {
        String sql = """
                SELECT COALESCE(SUM(d.cantidad), 0)
                FROM detalle_pedido d
                INNER JOIN pedido p ON p.id_pedido = d.id_pedido
                WHERE p.estado <> 'CANCELADO'
                """;

        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    private Map<LocalDate, BigDecimal> agruparDecimales(String sql, String columna) {
        Map<LocalDate, BigDecimal> resultado = new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getBigDecimal(columna)
            );
        });

        return resultado;
    }

    private Map<LocalDate, Integer> agruparEnteros(String sql, String columna) {
        Map<LocalDate, Integer> resultado = new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getInt(columna)
            );
        });

        return resultado;
    }
}
