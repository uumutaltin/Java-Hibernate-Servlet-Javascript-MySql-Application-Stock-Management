package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class BoxOrders {
// for procedure (not used)
    @Id
    private long box_receipt;
    private int cu_id;
    private String cu_name;
    private String cu_surname;
    private int cu_status;
    private int pro_id;
    private String pro_title;
    private int pro_sale_price;
    private int box_count;
    private int box_status;

}
