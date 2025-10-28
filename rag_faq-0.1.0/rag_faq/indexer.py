import os
import pandas as pd
from tqdm import tqdm
from langchain_openai import ChatOpenAI

# linha errada
# from langchain.schema import SystemMessage, HumanMessage

# linha certa!!!
from langchain_core.messages import SystemMessage, HumanMessage

from rag_faq.utils import load_prompt_template, format_prompt, parse_faq_response

def generate_faqs(config, project_dir, texts):
    """
    Generate FAQs (question-answer pairs) from a list of texts using an LLM.
    The output is saved as a CSV file in the specified project directory.
    """

    # Load LLM configuration
    llm_cfg = config["llm"]["faq_generator"]
    model = ChatOpenAI(
        model=llm_cfg["model"],
        temperature=llm_cfg["temperature"],
        openai_api_key=llm_cfg["api_key"],
        base_url=llm_cfg["provider"],
    )

    # Load prompt templates
    prompt_dir = config["paths"]["prompts_dir"]
    persona = load_prompt_template(os.path.join(prompt_dir, "persona.txt"))
    rules = load_prompt_template(os.path.join(prompt_dir, "rules.txt"))

    # Number of FAQs per text
    k = config.get("indexing", {}).get("questions_per_text", 3)

    all_rows = []

    for text in tqdm(texts, desc="Generating FAQs"):
        try:
            prompts = format_prompt(persona, rules, text, k)

            # Invoke the LLM
            response = model.invoke([
                SystemMessage(content=prompts["system"]),
                HumanMessage(content=prompts["user"])
            ])

            # Parse and extract Q&A pairs
            faqs = parse_faq_response(response.content, k)

            # Store each Q&A pair with its original text
            for faq in faqs:
                all_rows.append({
                    "source_text": text,
                    "question": faq["question"],
                    "answer": faq["answer"]
                })

        except Exception as e:
            print(f"[ERROR] Failed to process text: {text[:60]}... - {str(e)}")

    # Save to CSV
    df = pd.DataFrame(all_rows)
    output_path = os.path.join(project_dir, "faq.csv")
    df.to_csv(output_path, index=False, encoding="utf-8")
    print(f"✅ FAQ saved to: {output_path}")
