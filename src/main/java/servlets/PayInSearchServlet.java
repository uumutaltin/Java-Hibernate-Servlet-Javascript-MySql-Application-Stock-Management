package servlets;

import com.google.gson.Gson;
import entities.PayIn;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import utils.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "payInSearchServlet", value = "/payIn-search-get")
public class PayInSearchServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String ara = req.getParameter("search").trim().replaceAll(" +", "") + "*";
        ara="*"+ara;
        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sesi = sf.openSession();
        List<PayIn> ls = new ArrayList<>();
        try{
            ls = sesi.createSQLQuery("CALL payInSearch(?)")
                    .addEntity(PayIn.class)
                    .setParameter(1,ara)
                    .getResultList();
            System.out.println("Arama: " + ara);
        }catch (Exception e){
            System.err.println("payInSearchServlet Error : " + e);
        }finally {
            sesi.close();
        }

        Gson gson = new Gson();
        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);







    }
}
