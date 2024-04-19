// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

package com.ai4bharat.karya.data.local.daos

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import java.util.concurrent.Flow

@Dao
interface BasicDao<T> {
    /** Insert a single [record] into the table */
    @Insert
    suspend fun insert(record: T)

    /** Insert a [record] into the table. Will be followed by update in case of conflict. */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertForUpsert(record: T)

    /** Update a [record] in the table. Will be preceded by insert. */
    @Update(onConflict = OnConflictStrategy.IGNORE)
    suspend fun updateForUpsert(record: T)

    /** Insert a list of [records] into the table. Will be followed by update in case of conflict. */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertForUpsert(records: List<T>)

    /** Update a list of [records] in the table. Will be preceded by insert. */
    @Update(onConflict = OnConflictStrategy.IGNORE)
    suspend fun updateForUpsert(records: List<T>)


    //Clear all the table

}
