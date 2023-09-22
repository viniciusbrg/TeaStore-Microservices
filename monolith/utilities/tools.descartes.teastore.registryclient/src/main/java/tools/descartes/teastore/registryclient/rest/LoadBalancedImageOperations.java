package tools.descartes.teastore.registryclient.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import tools.descartes.teastore.registryclient.Service;
import tools.descartes.teastore.registryclient.loadbalancers.LoadBalancerTimeoutException;
import tools.descartes.teastore.registryclient.loadbalancers.ServiceLoadBalancer;
import tools.descartes.teastore.registryclient.util.NotFoundException;
import tools.descartes.teastore.entities.ImageSize;
import tools.descartes.teastore.entities.ImageSizePreset;
import tools.descartes.teastore.entities.Product;

/**
 * Wrapper for rest operations.
 * 
 * @author mediocre comments --> Simon, good code --> Norbert
 *
 */
public final class LoadBalancedImageOperations {

	private LoadBalancedImageOperations() {

	}

	/**
	 * Regenerates images.
	 * 
	 * @return List of status codes.
	 */
	public static List<Integer> regenerateImages() {
		List<Response> r = ServiceLoadBalancer.multicastRESTOperation(Service.IMAGE, "image", null,
				client -> client.getEndpointTarget().path("regenerateImages").request().get());
		if (r == null) {
			return new ArrayList<Integer>();
		}
		List<Integer> statuses = r.stream().filter(response -> response != null).map(response -> response.getStatus())
				.collect(Collectors.toList());
		// buffer all entities so that the connections are released to the connection
		// pool
		r.stream().filter(response -> response != null).forEach(response -> response.bufferEntity());
		return statuses;
	}
}
