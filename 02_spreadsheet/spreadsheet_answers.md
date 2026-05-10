\# Spreadsheet Answers





\## Cleaning Steps

1.Removing Duplicates:

Identify and delete rows that are exactly the same. This prevents double-counting transactions or users.



2.Standardizing Text \& Case

Inconsistent text (like "alpha mart" vs. "Alpha Mart" vs. "ALPHA MART") makes it impossible to group data.

Action: Convert all text to a consistent case (e.g., UPPER or Proper Case).



3\. Trimming Whitespace

Invisible spaces at the beginning or end of a word (e.g., " Alpha Mart ") often cause lookup formulas like VLOOKUP to fail.

Action: Use the TRIM function to remove extra spaces.



4\. Handling Missing or Null Values

Decide what to do with empty cells.

Action: You can either delete the row, fill it with a default value (like "Unknown" or 0), or use the average of the column.



5\. Fixing Data Types

Ensure that numbers are stored as numbers and dates are stored as dates. For example, if a risk score is written as "score:62", Excel sees it as text.

Action: Use "Find \& Replace" to remove the word "score:" so only the number remains, then change the column format to Number.



6\. Formatting Dates

Dates often come in different styles (01-03-26 vs. 2026/03/01).

Action: Standardize the entire column to a single format (usually YYYY-MM-DD) to ensure you can sort and filter by time correctly.



7\. Data Enrichment (VLOOKUP)

Adding missing information from another source to make your primary table more useful.

Example: Using your merchant\_master.csv to add "Category" and "HQ Country" to your raw transactions.



8\. Validation \& Outlier Detection

Check for "impossible" data, such as negative transaction amounts or risk scores that exceed the maximum limit (e.g., a score of 150 if the scale is 1–100).



\## Standardization Rules

1\.Name Standardization

Action: Remove extra spaces and unify the text case.

Rule: Apply TRIM() and UPPER().

Result: " alpha mart " and "Alpha  Mart" both become ALPHA MART.



2\. Date Format Standardization

Action: Ensure all dates follow the same syntax.

Rule: Convert all cells to YYYY-MM-DD format.

Result: 01/03/26 becomes 2026-03-01.



3\. Status Value Standardization

Action: Clean up inconsistent status descriptions and group them.

Rule: Convert to lowercase and simplify.

Any string containing "captured" $\\rightarrow$ captured

Any string containing "failed" or "timeout" $\\rightarrow$ failed

Any string containing "chargeback" $\\rightarrow$ chargeback

Result: "failed e05 timeout" becomes failed.



4\. Risk Score Standardization

Action: Extract the numerical value from text strings.

Rule: Remove prefixes like "score:" or "risk-" using "Find \& Replace" or a formula, then format the cell as a Number.

Result: "score:62" becomes 62.



5\. Gateway Region Standardization

Action: Fix inconsistent casing and fill blanks.

Rule: \* Convert to UPPERCASE (APAC, EU, US).

Enrichment Rule: If gateway\_region is blank, use the HQ Country from the Merchant Master file to assign the region (e.g., India $\\rightarrow$ APAC, USA $\\rightarrow$ US).



6\. Currency Conversion (amount\_usd)

Rule: Use the formula: raw\_amount / exchange\_rate.

Rates: \* INR: 83.0; EUR: 0.92; USD: 1.0



7\. Logical Flagging Rules

Once the data is cleaned, apply these exact logical tests:High Risk FlagSet to 1 if:• risk\_score $\\ge$ 70• OR status contains "chargeback"(Otherwise 0)



\## Lookup and Enrichment Logic

1\. The "Key" Standardization Logic

Before performing any lookup, you must create a "Clean Key" to ensure the files talk to each other correctly.

Merchant Name Key: Convert to UPPERCASE and TRIM all spaces.

Logic: ALPHA MART in the master file must match alpha mart in the raw file.

Currency Key: Ensure codes are exactly 3 letters (INR, USD, EUR).



2\. Exchange Rate Enrichment Logic

This logic converts local currency into a standard reporting currency (USD).

Source: exchange\_rates.csvJoin Condition: Match currency (Raw) to currency (Rates Table).

Calculation Logic:$$\\text{amount\\\_usd} = \\frac{\\text{raw\\\_amount}}{\\text{exchange\\\_rate}}$$



3. Region Backfilling Logic (Conditional Enrichment)

In the data, some gateway\_region cells are empty. Use the enriched HQ Country to fill these gaps.

Logic Rule: \* If HQ Country = "India" $\\rightarrow$ Set gateway\_region to APAC.

If HQ Country = "Germany" $\\rightarrow$ Set gateway\_region to EU.

If HQ Country = "USA" $\\rightarrow$ Set gateway\_region to US.



4.=IFERROR(VLOOKUP(...), "Merchant Missing")



\## Final Answers

Total raw rows: 30

Total cleaned rows: 29

Invalid or missing rows handled: 1

Top Region by GMV: APAC

Number of High Value Transactions: 8

Number of High Risk Transactions: 9

Top Merchant by Captured GMV: BETA STORES



\## Formula Samples

Convert all text to a consistent case: =PROPER(C2) or =UPPER(C2)

to remove extra spaces: =TRIM(C2) 

to search the lookup value :=L2\*VLOOKUP(M2,exchange\_rates!$B$2:$C$4,2,FALSE)

to remove extra spaces and comma and if there a blank then substitute with INVALID\_OR\_MISSING: =IF(TRIM(R2)="","INVALID\_OR\_MISSING",VALUE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(R2,"score:",""),"risk-",""),"risk:","")))









&#x20;      



&#x20;       



&#x20;   

