
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

        String sql = """
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    SUM(total) AS total_ventas
                FROM pedido
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """;

        Map<LocalDate, BigDecimal> resultado =
                new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getBigDecimal("total_ventas")
            );
        });

        return resultado;
    }

    @Override
    public Map<LocalDate, Integer> obtenerPedidosPorDia() {

        String sql = """
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    COUNT(*) AS total_pedidos
                FROM pedido
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """;

        Map<LocalDate, Integer> resultado =
                new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getInt("total_pedidos")
            );
        });

        return resultado;
    }

    @Override
    public Map<LocalDate, Integer> obtenerEntregasPorDia() {

        String sql = """
                SELECT
                    CAST(fecha_entrega AS DATE) AS fecha,
                    COUNT(*) AS total_entregas
                FROM pedido
                WHERE estado = 'ENTREGADO'
                  AND fecha_entrega IS NOT NULL
                GROUP BY CAST(fecha_entrega AS DATE)
                ORDER BY fecha ASC
                """;

        Map<LocalDate, Integer> resultado =
                new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getInt("total_entregas")
            );
        });

        return resultado;
    }

    @Override
    public Map<LocalDate, BigDecimal>
    obtenerTicketPromedioPorDia() {

        String sql = """
                SELECT
                    CAST(fecha_pedido AS DATE) AS fecha,
                    CAST(
                        ROUND(AVG(total), 2)
                        AS DECIMAL(15, 2)
                    ) AS ticket_promedio
                FROM pedido
                GROUP BY CAST(fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """;

        Map<LocalDate, BigDecimal> resultado =
                new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getBigDecimal("ticket_promedio")
            );
        });

        return resultado;
    }

    @Override
    public Map<LocalDate, Integer>
    obtenerUnidadesVendidasPorDia() {

        String sql = """
                SELECT
                    CAST(p.fecha_pedido AS DATE) AS fecha,
                    SUM(d.cantidad) AS total_unidades
                FROM pedido p
                INNER JOIN detalle_pedido d
                    ON p.id_pedido = d.id_pedido
                GROUP BY CAST(p.fecha_pedido AS DATE)
                ORDER BY fecha ASC
                """;

        Map<LocalDate, Integer> resultado =
                new LinkedHashMap<>();

        jdbcTemplate.query(sql, rs -> {
            resultado.put(
                    rs.getDate("fecha").toLocalDate(),
                    rs.getInt("total_unidades")
            );
        });

        return resultado;
    }

    @Override
    public BigDecimal obtenerImporteTotal() {

        String sql = """
                SELECT COALESCE(SUM(total), 0)
                FROM pedido
                """;

        return jdbcTemplate.queryForObject(
                sql,
                BigDecimal.class
        );
    }

    @Override
    public int obtenerTotalPedidos() {

        String sql = """
                SELECT COUNT(*)
                FROM pedido
                """;

        Integer resultado = jdbcTemplate.queryForObject(
                sql,
                Integer.class
        );

        return resultado != null ? resultado : 0;
    }

    @Override
    public int obtenerTotalEntregados() {

        String sql = """
                SELECT COUNT(*)
                FROM pedido
                WHERE estado = 'ENTREGADO'
                """;

        Integer resultado = jdbcTemplate.queryForObject(
                sql,
                Integer.class
        );

        return resultado != null ? resultado : 0;
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
                """;

        return jdbcTemplate.queryForObject(
                sql,
                BigDecimal.class
        );
    }

    @Override
    public int obtenerTotalUnidades() {

        String sql = """
                SELECT COALESCE(SUM(cantidad), 0)
                FROM detalle_pedido
                """;

        Integer resultado = jdbcTemplate.queryForObject(
                sql,
                Integer.class
        );

        return resultado != null ? resultado : 0;
    }
}
