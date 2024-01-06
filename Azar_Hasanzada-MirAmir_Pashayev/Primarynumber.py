def sieve_of_eratosthenes(upper_bound):
    if upper_bound < 2:
        return []

    # Initialize the boolean array
    primes = [True] * (upper_bound + 1)
    primes[0], primes[1] = False, False

    # Implementing Sieve of Eratosthenes
    for current in range(2, int(upper_bound**0.5) + 1):
        if primes[current]:
            for multiple in range(current*current, upper_bound + 1, current):
                primes[multiple] = False

    return [number for number, is_prime in enumerate(primes) if is_prime]

# Main execution
upper_bound = int(input("Enter an upper bound > "))
prime_numbers = sieve_of_eratosthenes(upper_bound)

print("\nPrime numbers between 2 and {} are: ".format(upper_bound))
print(", ".join(map(str, prime_numbers)))
