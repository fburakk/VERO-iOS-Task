/*************************************************************************
 *
 * Copyright 2016 Realm Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 **************************************************************************/

#ifndef REALM_VERSION_ID_HPP
#define REALM_VERSION_ID_HPP

#if defined(_WIN32) && !defined(__STDC_LIMIT_MACROS)
#define __STDC_LIMIT_MACROS
#endif

#include <cstdint>
#include <limits>
#include <ostream>

namespace realm {

struct VersionID {
    using version_type = uint_fast64_t;
    version_type version = std::numeric_limits<version_type>::max();
    uint_fast32_t index = 0;

    constexpr VersionID() = default;
    constexpr VersionID(version_type initial_version, uint_fast32_t initial_index) noexcept
    {
        version = initial_version;
        index = initial_index;
    }

    constexpr bool operator==(const VersionID& other) const noexcept
    {
        return version == other.version;
    }
    constexpr bool operator!=(const VersionID& other) const noexcept
    {
        return version != other.version;
    }
    constexpr bool operator<(const VersionID& other) const noexcept
    {
        return version < other.version;
    }
    constexpr bool operator<=(const VersionID& other) const noexcept
    {
        return version <= other.version;
    }
    constexpr bool operator>(const VersionID& other) const noexcept
    {
        return version > other.version;
    }
    constexpr bool operator>=(const VersionID& other) const noexcept
    {
        return version >= other.version;
    }
};

inline std::ostream& operator<<(std::ostream& os, VersionID id)
{
    os << "VersionID(" << id.version << ", " << id.index << ")";
    return os;
}

} // namespace realm

#endif // REALM_VERSION_ID_HPP
