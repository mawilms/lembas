import { expect, test } from 'vitest'
import { compareVersions, normalizeVersion } from '@/utils/versioning.ts'

test.each([
    ['v1.3.0', [1, 3, 0]],
    ['1.3.0', [1, 3, 0]],
    ['1.3.0v', [1, 3, 0]],
    ['v1.3.0v', [1, 3, 0]],
    ['v1.3.0a', [1, 3, 0]],
    ['1.3.0 a', [1, 3, 0]],
    ['1.3', [1, 3]],
    ['5.9.0 beta', [5, 9, 0]],
    ['1.0a', [1, 0]],
])('normalize different versioning patterns', (version, expected) => {
    const got = normalizeVersion(version)

    expect(got).toEqual(expected)
})

test.each([
    ['v1.3.1', 'v1.3.0', 1],
    ['v1.3.0', 'v1.3.1', -1],
    ['1.3.0 b', '1.3.0 a', 1],
])('compare different versions', (new_, old, expected) => {
    const got = compareVersions(new_, old)

    expect(got).toBe(expected)
})
