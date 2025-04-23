# Posts API (Ruby on Rails)

This is a simple Rails API that fetches posts from the external service [JSONPlaceholder](https://jsonplaceholder.typicode.com/posts), paginates the results using **Kaminari**, and returns only the `id` and `title` fields.

## 🚀 Tech Stack

- **Ruby**: 3.1.3  
- **Rails**: 7.2.2  
- **Kaminari**: For pagination  
- **RSpec**: For testing  
- **HTTParty**: To consume external API  
- **Caching**: Basic caching using `Rails.cache`

---

## 🔧 Getting Started

### 1. Clone the Repository

```bash
1) clone repo
git clone https://github.com/Bahubaliak/posts_api.git
cd posts_api

2) Install Gems
bundle install

3)run rails server
bin/rails server

4) API usage
curl http://localhost:3000/posts?page=2&per_page=5

