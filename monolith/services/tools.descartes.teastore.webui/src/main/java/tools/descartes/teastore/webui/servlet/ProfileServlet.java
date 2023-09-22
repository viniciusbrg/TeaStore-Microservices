/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package tools.descartes.teastore.webui.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import tools.descartes.teastore.auth.AuthFacade;
import tools.descartes.teastore.image.ImageFacade;
import tools.descartes.teastore.registryclient.Service;
import tools.descartes.teastore.registryclient.loadbalancers.LoadBalancerTimeoutException;

import tools.descartes.teastore.registryclient.rest.LoadBalancedImageOperations;

import tools.descartes.teastore.persistence.PersistenceFacade;
import tools.descartes.teastore.webui.servlet.elhelper.ELHelperUtils;
import tools.descartes.teastore.entities.Category;
import tools.descartes.teastore.entities.ImageSizePreset;
import tools.descartes.teastore.entities.Order;
import tools.descartes.teastore.entities.User;

/**
 * Servlet implementation for the web view of "Profile".
 * 
 * @author Andre Bauer
 */
@WebServlet("/profile")
public class ProfileServlet extends AbstractUIServlet {

  private static final long serialVersionUID = 1L;

  /**
   * @see HttpServlet#HttpServlet()
   */
  public ProfileServlet() {
    super();
  }

  /**
   * {@inheritDoc}
   */
  @Override
  protected void handleGETRequest(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException, LoadBalancerTimeoutException {
    checkforCookie(request, response);
    if (!AuthFacade.isLoggedIn(getSessionBlob(request))) {
      redirect("/", response);
    } else {

      request.setAttribute("storeIcon",
          ImageFacade.getWebImageIcon("icon"));
      request.setAttribute("CategoryList", PersistenceFacade.getAllCategories());
      request.setAttribute("title", "TeaStore Home");
      request.setAttribute("User", PersistenceFacade.getUserById(getSessionBlob(request).getUID()));
      request.setAttribute("Orders", PersistenceFacade.getAllOrdersFromUser(getSessionBlob(request).getUID()));
      request.setAttribute("login", AuthFacade.isLoggedIn(getSessionBlob(request)));
      request.setAttribute("helper", ELHelperUtils.UTILS);

      request.getRequestDispatcher("WEB-INF/pages/profile.jsp").forward(request, response);
    }
  }

}
