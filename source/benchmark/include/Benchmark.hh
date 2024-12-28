/*
 * Copyright (C) 2024 RealAhani - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the MIT license, which unfortunately won't be
 * written for another century.
 * You should have received a copy of the MIT license with
 * this file.
 */

#pragma once

/**
 * A Header Only Benchmark library
 * Dont use this file just use the macros in Profiler.hh
 */
namespace Profiler
{
/**
 * USE IT CAREFULLY
 * Utility class for calculating time
 */
class Timer
{
    // Some aliases for more convenient
    using micro       = std::chrono::microseconds;
    using steadyclock = std::chrono::steady_clock;


public:

    Timer()  = default;
    ~Timer() = default;
    // Some aliases for more convenient and public usage
    using timepoint = std::chrono::steady_clock::time_point;

    // Deleted members
    Timer(Timer const & timer)              = delete;
    Timer(Timer const && timer)             = delete;
    Timer & operator=(Timer const & other)  = delete;
    Timer & operator=(Timer const && other) = delete;


    /**
     * Calculate the elapsed time in micro-sec from start to end
     * @param noparam
     * @return elpased time in microsecond
     */
    [[nodiscard]]
    long long getDeltaTimeMicroSec() noexcept
    {
        using namespace std::chrono;
        initEndTime();
        return duration_cast<micro>(m_secondTime - m_firstTime).count();
    }

    /**
     * Start time now with cleaning last timer info
     * @param noparam
     * @return current start-time
     */
    [[maybe_unused]]
    long long startTimer() noexcept
    {
        // Clean the timer
        resetTimer();
        // Start new time and return it
        m_firstTime = steadyclock::now();
        return m_firstTime.time_since_epoch().count();
    }

private:

    /**
     * Zero it out all with reinit
     * @param noparam
     * @return noreturn
     */
    void resetTimer() noexcept
    {
        m_firstTime  = {};
        m_secondTime = {};
    }

    /**
     * Say the elapsed time whitout cleaning
     * @param noparam
     * @return elapsed time
     */
    [[maybe_unused]]
    long long initEndTime() noexcept
    {
        // What time is it now and return it
        m_secondTime = steadyclock::now();
        return m_secondTime.time_since_epoch().count();
    }

    timepoint m_firstTime;   // Use it for start time
    timepoint m_secondTime;  // Use it for end time
};

// DONT USE IT
// Needed Data for logging
struct BenchmarkData
{
    std::string name;         // Name of the section (function/block)
    long long   duration {};  // The whole latency of exec
    long long   startTime {};
    std::size_t threadID {};
};

/**
 * DONT USE IT
 * This class using Singleton as DP
 * e.g: FileHandle::startWriteBenchmark();
 * Used in Benchmark class Dont use it seperatedly
 * Write to a .json file with the given data
 */
class FileHandle
{
public:

    /**
     * This Function creat singleton and write the data to .json
     * @param Benchmark data
     * @return noreturn
     */
    static void startWriteBenchmark(BenchmarkData const & data) noexcept
    {
        FileHandle::makeInstance().writeInfo(data);
    }

    // Deleted members
    FileHandle(FileHandle &&)                  = delete;
    FileHandle(FileHandle const &)             = delete;
    FileHandle & operator=(FileHandle &&)      = delete;
    FileHandle & operator=(FileHandle const &) = delete;

private:

    /**
     * Init the file stream and write header
     * @param noparam
     */
    FileHandle() noexcept
    {
        m_fileStream = std::ofstream(outFileName);
        writeHeader();
    }

    /**
     * write the footer in the end of program bc the whole class is static
     * @param noparam
     */
    ~FileHandle() noexcept
    {
        writeFooter();
    }

    /**
     * Start Writing with starting the program
     * @param noparam
     * @return noreturn
     */
    void writeHeader() noexcept
    {
        m_fileStream << R"({"otherData": {},"traceEvents":[)";
    }

    /**
     * Write the footer in closing the program
     * @param noparam
     * @return noreturn
     */
    void writeFooter() noexcept
    {
        m_fileStream << "]}";
    }

    /**
     * Add the data to a .json
     * @param  benchmark data
     * @return noreturn
     */
    void writeInfo(BenchmarkData const & data) noexcept
    {
        // Avoid data-race
        std::lock_guard<std::mutex> lock(m_lock);
        // Dont write "," in first
        if (m_counter++ > 0) [[likely]]
        {
            m_fileStream << ",";
        }
        m_fileStream << "\n{";
        m_fileStream << R"("cat":"function",)";
        m_fileStream << R"("dur":)" << data.duration << ',';
        m_fileStream << R"("name":")" << data.name << "\",";
        m_fileStream << R"("ph":"X",)";
        m_fileStream << R"("pid":0,)";
        m_fileStream << R"("tid":)" << data.threadID << ',';
        m_fileStream << R"("ts":)" << data.startTime;
        m_fileStream << "}";
    }

    /**
     * Singleton instance creator
     * @param noparam
     * @return the instance of the class
     */
    static FileHandle & makeInstance() noexcept
    {
        static FileHandle instance {};
        return instance;
    }

    // Output.json name
    inline static std::string const outFileName = {"BenchMark.json"};
    // std::string_literals::operator""s("BenchMark.json", 15)};

    std::ofstream m_fileStream;
    std::mutex    m_lock;
    size_t m_counter = {};  // Line counter for this static class(FileHandle)
};

// DONT USE IT
// Benchmark the code
class BenchMark
{
public:

    /**
     * Creat benchmark info for given name
     * Can be name of the scoop, function, etc ...
     * @param name of the scoop
     */
    explicit BenchMark(std::string const & name) noexcept
    {
        m_data.name      = name;
        m_data.duration  = 0;
        m_data.startTime = m_timer.startTimer();
        m_data.threadID  = std::hash<std::thread::id> {}(
            std::this_thread::get_id());
    }

    /**
     * Write all the information about the benchmart to .json file
     * @param noparam
     */
    ~BenchMark() noexcept
    {
        m_data.duration = m_timer.getDeltaTimeMicroSec();
        FileHandle::startWriteBenchmark(m_data);
    }

    // Deleted members
    BenchMark()                              = delete;
    BenchMark(BenchMark &&)                  = delete;
    BenchMark(BenchMark const &)             = delete;
    BenchMark & operator=(BenchMark &&)      = delete;
    BenchMark & operator=(BenchMark const &) = delete;

private:

    Timer         m_timer;
    BenchmarkData m_data = {};
};

}  // namespace Profiler