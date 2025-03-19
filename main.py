import uvicorn
import nest_asyncio
import asyncio
from fastapi import FastAPI
from pydantic import BaseModel
from crawl4ai import AsyncWebCrawler

nest_asyncio.apply()
app = FastAPI()

class CrawlRequest(BaseModel):
    url: str

async def scrape_content_and_links(url):
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url=url, crawling_strategy="http")
        page_text = result.markdown
        links = []
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
    uvicorn.run(app, host="0.0.0.0", port=8000)
