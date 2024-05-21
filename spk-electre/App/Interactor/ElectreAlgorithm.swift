import Foundation

struct Alternative {
    let name: String
    var criteriaValues: [String: Double] // criterion code : value
}

struct Criterion {
    let name: String
    let weight: Double
    let code: String
}

final class ElectreAlgorithm {

    private let alternatives: [Alternative]
    private let criteria: [Criterion]

    init(
        alternatives: [Alternative],
        criteria: [Criterion]
    ) {
        self.alternatives = alternatives
        self.criteria = criteria

    }

    func execute() -> [Alternative] {
        let concordanceMatrix = calculateConcordanceMatrix()
        let discordanceMatrix = calculateDiscordanceMatrix()
        let aggregatedDominanceMatrix = calculateAggregatedDominanceMatrix(
            concordanceMatrix: concordanceMatrix,
            discordanceMatrix: discordanceMatrix
        )

        var outrankedAlternatives = Set<Int>()
        for i in 0..<alternatives.count {
            for j in 0..<alternatives.count {
                if aggregatedDominanceMatrix[i][j] {
                    outrankedAlternatives.insert(j)
                }
            }
        }

        let nonOutrankedAlternatives = (0..<alternatives.count)
            .filter { !outrankedAlternatives.contains($0) }
        return nonOutrankedAlternatives.map { alternatives[$0] }
    }

    private func calculateConcordanceThreshold(matrix: [[Double]]) -> Double {
        let numberOfAlternatives = Double(alternatives.count)
        let sum = matrix.flatMap { $0 }.reduce(0, +)

        return sum / (numberOfAlternatives * (numberOfAlternatives - 1))
    }

    private func calculateDiscordanceThreshold(matrix: [[Double]]) -> Double {
        let numberOfAlternatives = Double(alternatives.count)
        let sum = matrix.flatMap { $0 }.reduce(0, +)

        return sum / (numberOfAlternatives * (numberOfAlternatives - 1))
    }

    private func calculateConcordanceMatrix() -> [[Double]] {
        let numberOfAlternatives = alternatives.count
//        let numberOfCriteria = criteria.count

        var concordanceMatrix = Array(
            repeating: Array(repeating: 0.0, count: numberOfAlternatives),
            count: numberOfAlternatives
        )

        for i in 0..<numberOfAlternatives {
            for j in 0..<numberOfAlternatives {
                if i != j {
                    var concordanceValue = 0.0
                    for criterion in criteria {
                        if alternatives[i].criteriaValues[criterion.code]! >= alternatives[j]
                            .criteriaValues[criterion.code]! {
                            concordanceValue += criterion.weight
                        }
                    }
                    concordanceMatrix[i][j] = concordanceValue
                }
            }
        }

        return concordanceMatrix
    }

    private func calculateDiscordanceMatrix() -> [[Double]] {
        let numberOfAlternatives = alternatives.count

        var discordanceMatrix = Array(
            repeating: Array(repeating: 0.0, count: numberOfAlternatives),
            count: numberOfAlternatives
        )

        for i in 0..<numberOfAlternatives {
            for j in 0..<numberOfAlternatives {
                if i != j {
                    var maxDifference = 0.0
                    var totalDifference = 0.0
                    for criterion in criteria {
                        let difference = abs(
                            alternatives[i]
                                .criteriaValues[criterion.code]! - alternatives[j]
                                .criteriaValues[criterion.code]!
                        )
                        if difference > maxDifference {
                            maxDifference = difference
                        }
                        totalDifference += difference
                    }
                    discordanceMatrix[i][j] = maxDifference / totalDifference
                }
            }
        }

        return discordanceMatrix
    }

    private func calculateAggregatedDominanceMatrix(
        concordanceMatrix: [[Double]],
        discordanceMatrix: [[Double]]
    ) -> [[Bool]] {
        let numberOfAlternatives = concordanceMatrix.count
        var aggregatedDominanceMatrix = Array(
            repeating: Array(repeating: false, count: numberOfAlternatives),
            count: numberOfAlternatives
        )

        for i in 0..<numberOfAlternatives {
            for j in 0..<numberOfAlternatives {
                if i != j {
                    if concordanceMatrix[i][j] >=
                        calculateConcordanceThreshold(matrix: concordanceMatrix) &&
                        discordanceMatrix[i][j] <=
                        calculateDiscordanceThreshold(matrix: discordanceMatrix) {
                        aggregatedDominanceMatrix[i][j] = true
                    }
                }
            }
        }

        return aggregatedDominanceMatrix
    }
}
