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
package tools.descartes.teastore.persistence.rest;

import java.util.ArrayList;
import java.util.List;

import jakarta.ws.rs.Path;

import tools.descartes.teastore.persistence.domain.CategoryRepository;
import tools.descartes.teastore.persistence.repository.DataGenerator;
import tools.descartes.teastore.entities.Category;

/**
 * Persistence endpoint for CRUD operations on Categories.
 * @author Joakim von Kistowski
 *
 */
@Path("categories")
public class CategoryEndpoint extends AbstractCRUDEndpoint<Category> {

	/**
	 * {@inheritDoc}
	 */
	@Override
	public long createEntity(final Category category) {
		if (DataGenerator.GENERATOR.isMaintenanceMode()) {
			return -1L;
		}
		return CategoryRepository.REPOSITORY.createEntity(category);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Category findEntityById(final long id) {
		Category category = CategoryRepository.REPOSITORY.getEntity(id);
		if (category == null) {
			return null;
		}
		return new Category(category);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<Category> listAllEntities(final int startIndex, final int maxResultCount) {
		List<Category> categories = new ArrayList<Category>();
		for (Category c : CategoryRepository.REPOSITORY.getAllEntities(startIndex, maxResultCount)) {
			categories.add(new Category(c));
		}
		return categories;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean updateEntity(long id, Category category) {
		return CategoryRepository.REPOSITORY.updateEntity(id, category);
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean deleteEntity(long id) {
		if (DataGenerator.GENERATOR.isMaintenanceMode()) {
			return false;
		}
		return CategoryRepository.REPOSITORY.removeEntity(id);
	}
	
}
