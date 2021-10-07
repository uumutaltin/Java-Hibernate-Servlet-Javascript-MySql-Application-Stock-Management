package entities;

import lombok.Data;

import javax.persistence.*;


@Entity
@Data
public class BoxAction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int box_id;

    private int box_customer_id;

    @Column(name = "box_product_id")
    private int box_product_id;

    private int box_count;
    private long box_receipt;
    private int box_status;

    @OneToOne
    private Product product;

    @OneToOne
    private Customer customer;


}
