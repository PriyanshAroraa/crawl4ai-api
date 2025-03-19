import uvicorn
import nest_asyncio
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from crawl4ai import AsyncWebCrawler

nest_asyncio.apply()
app = FastAPI()

# ✅ Add CORS middleware to avoid browser errors
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class CrawlRequest(BaseModel):
    url: str

async def scrape_content_and_links(url):
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url=url)
        page_text = result.markdown
        links = []
        # Crawl4AI might return URLs in result.data list
        if result and hasattr(result, "data") and result.data:
            for page in result.data:
                if "url" in page:
                    links.append(page["url"])
        return page_text, links

@app.post("/scrape")
async def scrape(request: CrawlRequest):
    text_content, links = await scrape_content_and_links(request.url)
    return {
        "url": request.url,
        "content": text_content,
        "links": links
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=10000)
