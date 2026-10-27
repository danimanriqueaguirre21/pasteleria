package org.example.publicidad;

public class Promocion {

    private Integer idPromocion;
    private String titulo;
    private String descripcion;
    private String imagen;
    private boolean estado = true;

    public Promocion() {
    }

    public Promocion(Integer idPromocion, String titulo,
                     String descripcion, String imagen, boolean estado) {
        this.idPromocion = idPromocion;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.imagen = imagen;
        this.estado = estado;
    }

    public Integer getIdPromocion() {
        return idPromocion;
    }

    public void setIdPromocion(Integer idPromocion) {
        this.idPromocion = idPromocion;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
}
