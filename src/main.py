from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, lower, desc

# Create Spark session
spark = SparkSession.builder \
    .appName("HelloSpark") \
    .master("spark://spark-master:7077") \
    .getOrCreate()

# Sample data
data = [
    ("Hello world hello spark",),
    ("Apache spark is amazing",),
    ("Spark makes big data processing easy",),
    ("Hello apache spark community",)
]

df = spark.createDataFrame(data, ["text"])

print("\nOriginal Data:")
df.show(truncate=False)

# Word count
words_df = df.select(explode(split(col("text"), " ")).alias("word"))
word_count = words_df.select(lower(col("word")).alias("word")) \
    .groupBy("word") \
    .count() \
    .orderBy(desc("count"))

print("\nWord Count Results:")
word_count.show()

print("\n✅ Spark job completed successfully!")

spark.stop()
