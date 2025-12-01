<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movie Project – Queries</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&display=swap" rel="stylesheet">

    <!-- External CSS -->
    <link rel="stylesheet" href="css/moviematrix.css">
</head>
<body>

<div class="container">
    <h1>MovieMatrix</h1>
    <p class="subtitle">Find the films you love here.</p>

    <div class="grid">

        <!-- Q1 -->
        <div class="card">
            <h2>1) Movies by Producer</h2>
            <p>List all movies produced by a given producer.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q1"/>
                <label>
                    First name
                    <input type="text" name="firstName" />
                </label>
                <label>
                    Last name
                    <input type="text" name="lastName" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q2 -->
        <div class="card">
            <h2>2) Movies by Director</h2>
            <p>List all movies directed by a given director.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q2"/>
                <label>
                    First name
                    <input type="text" name="firstName" />
                </label>
                <label>
                    Last name
                    <input type="text" name="lastName" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q3 -->
        <div class="card">
            <h2>3) Most Expensive Movie by Producer</h2>
            <p>Find the most expensive movie a producer ever produced.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q3"/>
                <label>
                    First name
                    <input type="text" name="firstName" />
                </label>
                <label>
                    Last name
                    <input type="text" name="lastName" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q4 -->
        <div class="card">
            <h2>4) Movies Produced in a Year</h2>
            <p>Show all movies released in a specific year.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q4"/>
                <label>
                    Year
                    <input type="number" name="year" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q5 -->
        <div class="card">
            <h2>5) Actresses Not Working with Producer</h2>
            <p>Find actresses who never joined a movie by a given producer.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q5"/>
                <label>
                    Producer first name
                    <input type="text" name="firstName" />
                </label>
                <label>
                    Producer last name
                    <input type="text" name="lastName" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q6 -->
        <div class="card">
            <h2>6) Highest Paid Actress</h2>
            <p>Show the actress who earned the highest amount in a movie.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q6"/>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q7 -->
        <div class="card">
            <h2>7) Performers in a Movie</h2>
            <p>List all actors and actresses who joined a movie.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q7"/>
                <label>
                    Movie title
                    <input type="text" name="movieTitle" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q8 -->
        <div class="card">
            <h2>8) Movies Below a Price by Director</h2>
            <p>List movies under a cost threshold directed by a given director.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q8"/>
                <label>
                    Director first name
                    <input type="text" name="firstName" />
                </label>
                <label>
                    Director last name
                    <input type="text" name="lastName" />
                </label>
                <label>
                    Max cost
                    <input type="number" step="0.01" name="maxCost" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q9 -->
        <div class="card">
            <h2>9) Producers of Most Expensive Movies</h2>
            <p>List producers who produced the most expensive movies in a year.</p>
            <form action="queries" method="get">
                <input type="hidden" name="action" value="q9"/>
                <label>
                    Year
                    <input type="number" name="year" />
                </label>
                <button class="btn" type="submit">Run query</button>
            </form>
        </div>

        <!-- Q10 -->
        <div class="card">
            <h2>10) Most Watched Movies</h2>
            <p>Find movies people watch more for a given actor or actress.</p>

            <div class="two-buttons">
                <form action="queries" method="get">
                    <input type="hidden" name="action" value="q10_actor"/>
                    <label>
                        Actor person ID
                        <input type="number" name="personId" />
                    </label>
                    <button class="btn" type="submit">Actor</button>
                </form>

                <form action="queries" method="get">
                    <input type="hidden" name="action" value="q10_actress"/>
                    <label>
                        Actress person ID
                        <input type="number" name="personId" />
                    </label>
                    <button class="btn" type="submit">Actress</button>
                </form>
            </div>
        </div>

    </div>
</div>

</body>
</html>
